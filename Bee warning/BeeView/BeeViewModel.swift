//
//  BeeViewModel.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import FirebaseStorage

// View model to manage the bee reports.
class BeeViewModel: ObservableObject {
    
    // Singleton shared for the viewModel
    static let shared = BeeViewModel()
    
    // Published variable to hold the user's bee reports.
    @Published var myReports = [FireBee]()
    
    // Published variable to hold all bee reports.
    @Published var bees = [FireBee]()
    
    // Published variable to hold all comments.
    @Published var comments = [FireComment]()
    
    // Published array to hold nearby Bees counts for different radii.
    @Published var nearbyBeesCounts = [Int](repeating: 0, count: 9)
    
    // Published variable to hold the remaining time in seconds.
    @Published var remainingTime: TimeInterval = 0
    
    // Dictionary to store profile image URLs
    @Published var profileImageURLs: [String: URL] = [:]
    
    // Computed property to get the count of each kind of bee
    var beeCountsByKind: [BeeKind: Int] {
        var counts = [BeeKind: Int]()
        
        for bee in bees {
            if let kind = BeeKind(rawValue: bee.kind) {
                counts[kind, default: 0] += 1
            }
        }
        
        return counts
    }
    
    // Listener for Firestore updates.
    private var listener: ListenerRegistration?
    
    // Firebase authentication instance.
    private let firebaseAuthentication = Auth.auth()
    
    // Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    
    /// Firebase Storage instance.
    private let firebaseStorage = Storage.storage()
    
    // Timer for auto-deleting old reports.
    private var timer: Timer?
    
    // LocationManager instance
    private var locationManager: LocationManager
    
    // A set to track the IDs of notified comments
    private var notifiedCommentIDs: Set<String> {
        get {
            let ids = UserDefaults.standard.array(forKey: "notifiedCommentIDs") as? [String] ?? []
            return Set(ids)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "notifiedCommentIDs")
        }
    }
    
    private var lastResetDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "lastResetDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastResetDate")
        }
    }
    
    init() {
        self.locationManager = LocationManager()
        self.fetchBees()
        self.updateTimer()
        self.fetchMyBeesOnLaunch()
//        Task {
//            await self.generateDemoBeeReports()
//        }
    }
    
    // Creates a new bee report.
    func createBee(userName: String, title: String, description: String, address: String, location: GeoPoint, kind: BeeKind.RawValue) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newBee = FireBee(userId: userId, userName: userName, title: title, description: description, address: address, location: location, kind: kind, timestamp: Timestamp(), editTimestamp: nil)
        
        do {
            try self.firebaseFirestore.collection("bees").addDocument(from: newBee) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added successfully")
                }
            }
        } catch {
            print("Error encoding document: \(error.localizedDescription)")
        }
    }
    
    // Fetches all bee reports.
    func fetchBees() {
        guard (self.firebaseAuthentication.currentUser?.uid) != nil else {
            print("User is not signed in")
            return
        }
        
        self.listener = self.firebaseFirestore.collection("bees")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching bees: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }
                
                let bees = snapshot.documents.compactMap { document -> FireBee? in
                    do {
                        var bee = try document.data(as: FireBee.self)
                        bee.id = document.documentID
                        return bee
                    } catch {
                        print("Error decoding Bee: \(error)")
                        return nil
                    }
                }
                self.bees = bees
//                self.deleteOldReports()
            }
    }
    
    // Fetches the current user's bee reports.
    func fetchMyBees(completion: (() -> Void)? = nil) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            completion?()
            return
        }
        
        self.listener = self.firebaseFirestore.collection("bees")
            .whereField("userId", isEqualTo: userId)  
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching bees: \(error.localizedDescription)")
                    completion?()
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    completion?()
                    return
                }
                
                let bees = snapshot.documents.compactMap { document -> FireBee? in
                    do {
                        var bee = try document.data(as: FireBee.self)
                        bee.id = document.documentID
                        return bee
                    } catch {
                        print("Error decoding Bee: \(error)")
                        return nil
                    }
                }
                
                self.myReports = bees
//                self.deleteOldReports()
                completion?()
                
            }
    }
    
    // Edit bee report.
    func editBee(withId id: String, newTitle: String, newDescription: String, newBeeKind: BeeKind.RawValue) {
        let beeReport = firebaseFirestore.collection("bees").document(id)
        
        beeReport.updateData(["title": newTitle,
                              "description": newDescription,
                              "kind": newBeeKind,
                              "editTimestamp": Timestamp()
                             ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    // Deletes a bee report with the given ID.
    func deleteBees(withId id: String?) {
        guard let id = id else {
            print("Item has no id!")
            return
        }
        
        // delete comments associated with the bee
        deleteReportComments(forBeeId: id)
        
        // delete the bee report
        firebaseFirestore.collection("bees").document(id).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Bee report deleted successfully")
            }
        }
    }
    
    // Starts a timer to auto-delete old reports.
//    func deleteOldReports() {
//        let now = Date()
//        for bee in bees {
//            if let beeDate = bee.timestamp.dateValue() as Date?, now.timeIntervalSince(beeDate) > 7200 { // 2H 7200
//                deleteBees(withId: bee.id)
//                print("auto delete deleted a report title: \(bee.title), Time of creation: \(bee.timestamp.dateValue())")
//            }
//        }
//    }
    
    // Method to update the counts of nearby bees within different radii
    func updateNearbyBeesCounts(userLocation: CLLocation) {
        // Clear previous counts
        nearbyBeesCounts = [Int](repeating: 0, count: 9)
        
        let radii: [CLLocationDistance] = [5, 10, 50, 100, 500, 1000, 5000, 10000, 50000] // radii in meters
        
        for bee in bees {
            let beeLocation = CLLocation(latitude: bee.location.latitude, longitude: bee.location.longitude)
            let distance = userLocation.distance(from: beeLocation)
            
            for (index, radius) in radii.enumerated() {
                if distance <= radius {
                    nearbyBeesCounts[index] += 1
                    break
                }
            }
        }
    }
    
    // Deletes bee reports older than 2 hours and update the counts of nearby bees.
    func updateTimer() {
        // Schedule a timer to execute (set to 0.5 sec)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Delete old reports
//            self.deleteOldReports()
            // Trigger filter bees when bees list updates
            if let userLocation = self.locationManager.userLocation {
                self.updateNearbyBeesCounts(userLocation: userLocation)
            }
        }
    }
    
    // Start the countdown timer.
    func startTimer(for bee: FireBee) {
        let countdownEnd = bee.timestamp.dateValue().addingTimeInterval(2 * 60 * 60)
        self.timer?.invalidate() // Invalidate any existing timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let remaining = countdownEnd.timeIntervalSinceNow
            self.remainingTime = max(remaining, 0)
            if remaining <= 0 {
                timer.invalidate()
            }
        }
    }
    
    // Format time interval into a string.
    func timeString(from time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // calculate percentage of bees in the nearbyBeesCounts for doughnut chart
    func percentage(of count: Int, in total: Int) -> String {
        guard total > 0 else { return "0%" }
        let percent = (Double(count) / Double(total)) * 100
        return String(format: "%.1f%%", percent)
    }
    
    // Function to save the like status to Firestore
    func saveLikeStatus(for beeId: String, isLiked: Bool, userId: String) {
        let userLikesRef = firebaseFirestore.collection("userLikes").document(userId)
        
        userLikesRef.getDocument { document, _ in
            if let document = document, document.exists {
                if isLiked {
                    userLikesRef.updateData(["likedBees": FieldValue.arrayUnion([beeId])])
                } else {
                    userLikesRef.updateData(["likedBees": FieldValue.arrayRemove([beeId])])
                }
            } else {
                if isLiked {
                    userLikesRef.setData(["likedBees": [beeId]])
                }
            }
        }
    }
    
    // Function to load the like status from Firestore
    func fetchLikeStatus(for beeId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            completion(false)
            return
        }
        
        let userLikesRef = firebaseFirestore.collection("userLikes").document(currentUserId)
        
        userLikesRef.getDocument { [weak self] document, _ in
            guard self != nil else { return }
            
            if let document = document, document.exists, let data = document.data(), let likedBees = data["likedBees"] as? [String] {
                let isLiked = likedBees.contains(beeId)
                completion(isLiked)
                
            } else {
                completion(false)
            }
        }
    }
    
    // Function to update the like status in Firestore
    func updateBeeLikeStatus(withId id: String, shouldLike: Bool) {
        guard let currentUserId = firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let incrementValue: Int64 = shouldLike ? 1 : -1
        let beeReport = firebaseFirestore.collection("bees").document(id)
        
        beeReport.updateData(["likes": FieldValue.increment(incrementValue)]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
                self.saveLikeStatus(for: id, isLiked: shouldLike, userId: currentUserId)
            }
        }
    }
    
    // Function to add a comment to a bee report
    func addComment(toBeeId beeId: String, commentText: String, username: String, color: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newcomment = FireComment(userId: userId, beeId: beeId, username: username, text: commentText, timestamp: Timestamp(), color: color)
        
        do {
            try self.firebaseFirestore.collection("comments").addDocument(from: newcomment) { error in
                if let error = error {
                    print("Error adding comment: \(error.localizedDescription)")
                } else {
                    print("comment added successfully")
                    self.fetchComments(forBeeId: beeId)
                }
            }
        } catch {
            print("Error encoding comment: \(error.localizedDescription)")
        }
    }
    
    // Fetches all comments for a specific bee ID
    func fetchComments(forBeeId beeId: String) {  // swiftlint:disable:this cyclomatic_complexity
        guard let currentUserId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        self.listener = self.firebaseFirestore.collection("comments")
            .whereField("beeId", isEqualTo: beeId) // Filter comments by beeId
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching comments: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }
                
                let newComments = snapshot.documentChanges.filter { $0.type == .added }.compactMap { documentChange -> FireComment? in
                    do {
                        var comment = try documentChange.document.data(as: FireComment.self)
                        comment.id = documentChange.document.documentID
                        return comment
                    } catch {
                        print("Error decoding comment: \(error)")
                        return nil
                    }
                }
                
                // Process each new comment
                for comment in newComments {
                    // Avoid notifying about the user's own comments
                    if comment.userId != currentUserId {
                        // Check if the comment has already been notified
                        if !self.notifiedCommentIDs.contains(comment.id ?? "") {
                            // Find the related bee report from the user's reports
                            if let bee = self.myReports.first(where: { $0.id == beeId }) {
                                NotificationManger.shared.scheduleCommentLocalNotification(for: comment, bee: bee)
                                // Add the comment ID to the set of notified IDs
                                self.notifiedCommentIDs.insert(comment.id ?? "")
                            }
                        }
                    }
                }
                
                // Update the comments array with the latest comments
                self.comments = snapshot.documents.compactMap { document -> FireComment? in
                    do {
                        var comment = try document.data(as: FireComment.self)
                        comment.id = document.documentID
                        return comment
                    } catch {
                        print("Error decoding comment: \(error)")
                        return nil
                    }
                }
                
                for comment in comments {
                    self.fetchUserProfileImageURL(for: comment.userId)
                }
                
//                self.deleteOldReports()
                resetNotifiedCommentIDsIfNeeded()
            }
    }
    
    // Delete a comment with the given ID.
    func deleteComment(withId id: String?) {
        guard let id = id else {
            print("Item has no id!")
            return
        }
        
        firebaseFirestore.collection("comments").document(id).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            }
        }
    }
    
    // method to delete all comments associated with a specific bee ID
    func deleteReportComments(forBeeId beeId: String) {
        self.firebaseFirestore.collection("comments")
            .whereField("beeId", isEqualTo: beeId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching comments for deletion: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No comments found for beeId: \(beeId)")
                    return
                }
                
                // Iterate through each comment document and delete it
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting comment: \(error.localizedDescription)")
                        } else {
                            print("Comment deleted successfully")
                        }
                    }
                }
            }
    }
    
    // Fetches profile image URLs for each user associated with the ID
    func fetchUserProfileImageURL(for userId: String) {
        let storageRef = firebaseStorage.reference().child("profile_images/\(userId).png")
        
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error fetching profile image URL: \(error.localizedDescription)")
                return
            }
            
            if let url = url {
                DispatchQueue.main.async {
                    self.profileImageURLs[userId] = url
                    //                    print("profile Image Loded")
                }
            }
        }
    }
    
    // Method to reverse geocode location into an address
    func reverseGeocode(location: CLLocation, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion("Unknown location")
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion("Unknown location")
                return
            }
            
            let addressLines = [
                placemark.thoroughfare, // Street
                placemark.locality,     // City
                placemark.administrativeArea, // State
                placemark.country       // Country
            ].compactMap { $0 }
            
            let address = addressLines.joined(separator: ", ")
            completion(address)
        }
    }
    
    // function to restart the comment ID set
    func resetNotifiedCommentIDsIfNeeded() {
        let now = Date()
        
        if let lastReset = lastResetDate, now.timeIntervalSince(lastReset) < 24 * 60 * 60 {
            return
        }
        
        notifiedCommentIDs = []
        lastResetDate = now
    }
    
    // method to get a specific report from the Bee list
    func getBee(byId id: String) -> FireBee? {
        return bees.first { $0.id == id }
    }
    
    // Fetches bee reports belonging to the current user at app launch.
    func fetchMyBeesOnLaunch() {
        fetchMyBees { [weak self] in
            guard let self = self else { return }
            for bee in self.myReports {
                self.fetchComments(forBeeId: bee.id ?? "")
            }
        }
    }
    
//     Function to generate 100 different bee reports in famous locations globally
    
//        func generateDemoBeeReports() async {
//            // Famous locations (latitude, longitude)
//            let famousAndRandomLocations = [
//                ("Eiffel Tower, Paris", CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945)),
//                ("Statue of Liberty, New York", CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445)),
//                ("Great Wall of China", CLLocationCoordinate2D(latitude: 40.4319, longitude: 116.5704)),
//                ("Sydney Opera House, Australia", CLLocationCoordinate2D(latitude: -33.8568, longitude: 151.2153)),
//                ("Christ the Redeemer, Rio de Janeiro", CLLocationCoordinate2D(latitude: -22.9519, longitude: -43.2105)),
//                ("Pyramids of Giza, Egypt", CLLocationCoordinate2D(latitude: 29.9792, longitude: 31.1342)),
//                ("Taj Mahal, India", CLLocationCoordinate2D(latitude: 27.1751, longitude: 78.0421)),
//                ("Colosseum, Rome", CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922)),
//                ("Machu Picchu, Peru", CLLocationCoordinate2D(latitude: -13.1631, longitude: -72.5450)),
//                ("Mount Fuji, Japan", CLLocationCoordinate2D(latitude: 35.3606, longitude: 138.7274)),
//                ("Golden Gate Bridge, San Francisco", CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783)),
//                ("Stonehenge, UK", CLLocationCoordinate2D(latitude: 51.1789, longitude: -1.8262)),
//                ("Niagara Falls, Canada", CLLocationCoordinate2D(latitude: 43.0962, longitude: -79.0377)),
//                ("Burj Khalifa, Dubai", CLLocationCoordinate2D(latitude: 25.1972, longitude: 55.2744)),
//                ("Petra, Jordan", CLLocationCoordinate2D(latitude: 30.3285, longitude: 35.4444)),
//                ("Santorini, Greece", CLLocationCoordinate2D(latitude: 36.3932, longitude: 25.4615)),
//                ("Mount Kilimanjaro, Tanzania", CLLocationCoordinate2D(latitude: -3.0674, longitude: 37.3556)),
//                ("Angkor Wat, Cambodia", CLLocationCoordinate2D(latitude: 13.4125, longitude: 103.8667)),
//                ("Times Square, New York", CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)),
//                ("The Louvre, Paris", CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3376)),
//                ("Brandenburg Gate, Berlin", CLLocationCoordinate2D(latitude: 52.5163, longitude: 13.3777)),
//                ("Berlin TV Tower", CLLocationCoordinate2D(latitude: 52.5208, longitude: 13.4094)),
//                ("East Side Gallery, Berlin", CLLocationCoordinate2D(latitude: 52.5054, longitude: 13.4396)),
//                ("Museum Island, Berlin", CLLocationCoordinate2D(latitude: 52.5169, longitude: 13.4019)),
//                ("Checkpoint Charlie, Berlin", CLLocationCoordinate2D(latitude: 52.5076, longitude: 13.3904)),
//                ("Reichstag Building, Berlin", CLLocationCoordinate2D(latitude: 52.5186, longitude: 13.3760)),
//                ("Berlin Zoological Garden", CLLocationCoordinate2D(latitude: 52.5073, longitude: 13.3372)),
//                ("Charlottenburg Palace, Berlin", CLLocationCoordinate2D(latitude: 52.5206, longitude: 13.2956)),
//                ("Potsdamer Platz, Berlin", CLLocationCoordinate2D(latitude: 52.5096, longitude: 13.3761)),
//                ("Gendarmenmarkt, Berlin", CLLocationCoordinate2D(latitude: 52.5138, longitude: 13.3927)),
//                ("Uluru, Australia", CLLocationCoordinate2D(latitude: -25.3444, longitude: 131.0369)),
//                ("Mount Everest, Nepal", CLLocationCoordinate2D(latitude: 27.9881, longitude: 86.9250)),
//                ("Table Mountain, South Africa", CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241)),
//                ("Sagrada Familia, Barcelona", CLLocationCoordinate2D(latitude: 41.4036, longitude: 2.1744)),
//                ("Acropolis of Athens, Greece", CLLocationCoordinate2D(latitude: 37.9715, longitude: 23.7257)),
//                ("Hollywood Sign, Los Angeles", CLLocationCoordinate2D(latitude: 34.1341, longitude: -118.3215)),
//                ("Forbidden City, Beijing", CLLocationCoordinate2D(latitude: 39.9163, longitude: 116.3971)),
//                ("Victoria Falls, Zambia/Zimbabwe", CLLocationCoordinate2D(latitude: -17.9243, longitude: 25.8567)),
//                ("The Shard, London", CLLocationCoordinate2D(latitude: 51.5045, longitude: -0.0865)),
//                ("Chichen Itza, Mexico", CLLocationCoordinate2D(latitude: 20.6843, longitude: -88.5678)),
//                ("Moai Statues, Easter Island", CLLocationCoordinate2D(latitude: -27.1212, longitude: -109.3664)),
//                ("Lake Bled, Slovenia", CLLocationCoordinate2D(latitude: 46.3625, longitude: 14.0936)),
//                ("Banff National Park, Canada", CLLocationCoordinate2D(latitude: 51.4968, longitude: -115.9281)),
//                ("Plitvice Lakes, Croatia", CLLocationCoordinate2D(latitude: 44.8804, longitude: 15.6164)),
//                ("Cinque Terre, Italy", CLLocationCoordinate2D(latitude: 44.1270, longitude: 9.7094)),
//                ("Ha Long Bay, Vietnam", CLLocationCoordinate2D(latitude: 20.9101, longitude: 107.1839)),
//                ("Alhambra, Spain", CLLocationCoordinate2D(latitude: 37.1760, longitude: -3.5881)),
//                ("Antelope Canyon, USA", CLLocationCoordinate2D(latitude: 36.8619, longitude: -111.3743)),
//                ("Salar de Uyuni, Bolivia", CLLocationCoordinate2D(latitude: -20.1338, longitude: -67.4891)),
//                ("Mount Cook, New Zealand", CLLocationCoordinate2D(latitude: -43.5950, longitude: 170.1410)),
//                ("Matterhorn, Switzerland", CLLocationCoordinate2D(latitude: 45.9763, longitude: 7.6586)),
//                ("Serengeti National Park, Tanzania", CLLocationCoordinate2D(latitude: -2.3333, longitude: 34.8333)),
//                ("Blue Lagoon, Iceland", CLLocationCoordinate2D(latitude: 63.8804, longitude: -22.4495)),
//                ("Hagia Sophia, Istanbul", CLLocationCoordinate2D(latitude: 41.0086, longitude: 28.9802)),
//                ("Mount Denali, Alaska", CLLocationCoordinate2D(latitude: 63.0695, longitude: -151.0074)),
//                ("Petronas Towers, Malaysia", CLLocationCoordinate2D(latitude: 3.1578, longitude: 101.7126)),
//                ("Rialto Bridge, Venice", CLLocationCoordinate2D(latitude: 45.4384, longitude: 12.3365)),
//                ("Angel Falls, Venezuela", CLLocationCoordinate2D(latitude: 5.9701, longitude: -62.5353)),
//                ("Neuschwanstein Castle, Germany", CLLocationCoordinate2D(latitude: 47.5576, longitude: 10.7498)),
//                ("Vatican City", CLLocationCoordinate2D(latitude: 41.9029, longitude: 12.4534)),
//    
//                // 15 random bee locations near your area
//                ("Bee Location 1", CLLocationCoordinate2D(latitude: 52.467601, longitude: 13.4435934)),
//                ("Bee Location 2", CLLocationCoordinate2D(latitude: 52.467080, longitude: 13.426147)),
//                ("Bee Location 3", CLLocationCoordinate2D(latitude: 52.467561, longitude: 13.413069)),
//                ("Bee Location 4", CLLocationCoordinate2D(latitude: 52.744849, longitude: 13.429876)),
//                ("Bee Location 5", CLLocationCoordinate2D(latitude: 52.452555, longitude: 13.141247)),
//                ("Bee Location 6", CLLocationCoordinate2D(latitude: 52.571140, longitude: 13.435940)),
//                ("Bee Location 7", CLLocationCoordinate2D(latitude: 52.467302, longitude: 13.565571)),
//                ("Bee Location 8", CLLocationCoordinate2D(latitude: 52.402818, longitude: 12.435071)),
//                ("Bee Location 9", CLLocationCoordinate2D(latitude: 52.327763, longitude: 13.371876)),
//                ("Bee Location 10", CLLocationCoordinate2D(latitude: 52.467838, longitude: 13.435676)),
//                ("Bee Location 11", CLLocationCoordinate2D(latitude: 52.467202, longitude: 13.338041)),
//                ("Bee Location 12", CLLocationCoordinate2D(latitude: 52.467015, longitude: 13.435734)),
//                ("Bee Location 13", CLLocationCoordinate2D(latitude: 52.467280, longitude: 12.411150)),
//                ("Bee Location 14", CLLocationCoordinate2D(latitude: 52.4467390, longitude: 13.435237)),
//                ("Bee Location 15", CLLocationCoordinate2D(latitude: 52.542434, longitude: 13.310228))
//            ]
//    
//            // List of possible bee kinds
//            let beeKinds: [BeeKind] = BeeKind.allCases
//    
//            for _ in 1...150 {
//                // Randomly select location
//                let randomLocation = famousAndRandomLocations.randomElement()!
//                let geoPoint = GeoPoint(latitude: randomLocation.1.latitude, longitude: randomLocation.1.longitude)
//    
//                // Randomly select a bee kind
//                let randomBeeKind = beeKinds.randomElement()!.rawValue
//    
//                // Generate random title and description with some bee puns and fun descriptions
//                let title = "\(randomLocation.0)! 🐝 "
//                let description = """
//                A \(randomBeeKind) \(randomLocation.0)🐝
//                """
//                // Create the bee report
//                createBee(userName: "Demo User", title: title, description: description, address: randomLocation.0, location: geoPoint, kind: randomBeeKind)
//    
//                // Add a short delay to simulate the reports being generated naturally
//                try? await _Concurrency.Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...2_000_000_000)) // 2 to 6 seconds delay
//            }
//        }
}
