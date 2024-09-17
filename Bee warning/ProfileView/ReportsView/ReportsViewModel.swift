//
//  ReportsViewModel.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// ViewModel class to manage user reports for the FireBee warning application
class ReportsViewModel: ObservableObject {

    // singleton shared for the viewModel
    static let shared = ReportsViewModel()

    @Published var userReports = [FireBee]()  // Published array to store user reports

    private var listener: ListenerRegistration?  // Firestore listener for real-time updates
    private let firebaseAuthentication = Auth.auth()  // Firebase authentication instance
    private let firebaseFirestore = Firestore.firestore()  // Firestore database instance

    // Initializer to fetch the user report list upon creation of the ViewModel
    init() {
        self.fetchUserReportList()
    }

    // Function to create a new report item
    // Parameters:
    // - title: The title of the report
    // - description: The description of the report
    // - location: The GeoPoint representing the location of the report
    // - kind: The kind of bee as a raw value string
    func createReportItem(userName: String, title: String, description: String, location: GeoPoint, kind: BeeKind.RawValue) {
        // Check if the user is signed in
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }

        // Create a new Bee report instance
        let newReport = FireBee(userId: userId, userName: userName, title: title, description: description, address: "", location: location, kind: kind, timestamp: Timestamp(), editTimestamp: nil)

        // Try to add the new report to the Firestore collection
        do {
            try self.firebaseFirestore.collection("reports").addDocument(from: newReport) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Report added successfully")
                }
            }
        } catch {
            print("Error encoding document: \(error.localizedDescription)")
        }
    }

    // Function to fetch the user's report list
    func fetchUserReportList() {
        // Check if the user is signed in
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }

        // Set up a listener to fetch reports from Firestore in real-time
        self.listener = self.firebaseFirestore.collection("reports")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching reports: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }

                // Decode the reports from the snapshot
                let bees = snapshot.documents.compactMap { document -> FireBee? in
                    do {
                        var bee = try document.data(as: FireBee.self)
                        bee.id = document.documentID
                        return bee
                    } catch {
                        print("Error decoding report: \(error)")
                        return nil
                    }

                }
                // Sort the reports by timestamp in descending order (newest first)
                self.userReports = bees.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            }
    }

    // Function to delete a report item by its ID
    // Parameters:
    // - id: The ID of the report to be deleted
    func deleteReportItem(withId id: String?) {
        // Check if the ID is valid
        guard let id = id else {
            print("Item has no id!")
            return
        }

        // Delete the report from Firestore
        firebaseFirestore.collection("reports").document(id).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            }
        }
    }
    
    // Edit bee report.
//    func editBee(withId id: String, newTitle: String, newDescription: String, newBeeKind: BeeKind.RawValue) {
//        let beeReport = firebaseFirestore.collection("reports").document(id)
//        
//        beeReport.updateData(["title": newTitle,
//                              "description": newDescription,
//                              "kind": newBeeKind,
//                              "editTimestamp": Timestamp()
//                             ]) { error in
//            if let error = error {
//                print("Error updating document: \(error.localizedDescription)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//    }
}
