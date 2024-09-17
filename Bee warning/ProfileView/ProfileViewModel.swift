//
//  ProfileViewModel.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CoreData
import UIKit

/// ViewModel to manage user authentication and profile data.
class ProfileViewModel: ObservableObject {

    // Singleton instance for the ViewModel
    static let shared = ProfileViewModel()

    /// Published variable to track the currently signed-in user.
    @Published private(set) var user: FireUser?

    /// Published variable to track the user's SOS profile.
    @Published var sosProfile: Sos?

    /// Published variable to track the user's profile image.
    @Published var profileImage: UIImage?

    // Firestore listener for real-time updates
    private var listener: ListenerRegistration?

    /// Firebase Authentication instance.
    private let firebaseAuthntication = Auth.auth()

    /// Firebase Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    
    /// Firebase Storage instance.
    private let firebaseStorage = Storage.storage()

    init() {
        /// Initialize and check if the user is already signed in.
        checkAuth()
    }

    /// Check if the user is currently signed in.
    func checkAuth() {
        guard let currentUser = self.firebaseAuthntication.currentUser else {
            print("No user logged in!")
            return
        }
        self.fetchFirestoreUser(withId: currentUser.uid)
    }

    /// Send a password reset email to the specified address.
    func recoverPassword(email: String) {
        firebaseAuthntication.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent.")
            }
        }
    }

    /// Fetch user data from Firestore based on the provided user ID.
    func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error fetching user: \(error)")
                return
            }

            guard let document else {
                print("Document does not exist")
                return
            }

            do {
                // Decode the Firestore document into a FireUser object
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }

    /// Create a new SOS profile for the user in Firestore.
    func createUserSosProfile(
        id: String,
        bloodType: String,
        username: String,
        birthday: Date,
        emergencyContacts: [EmergencyContact],
        medicalConditions: String,
        allergies: String,
        address: Address
    ) {
        let newUser = Sos(
            id: id,
            bloodType: bloodType,
            username: username,
            birthday: birthday,
            registeredAt: Date(),
            emergencyContacts: emergencyContacts,
            medicalConditions: medicalConditions,
            allergies: allergies,
            address: address
        )

        do {
            try self.firebaseFirestore.collection("sos").document(id).setData(from: newUser)
        } catch {
            print("Error saving SOS profile in Firestore: \(error)")
        }
    }

    /// Fetch the SOS profile of the currently signed-in user.
    func fetchSosProfile() {
        guard let userId = self.firebaseAuthntication.currentUser?.uid else {
            print("User is not signed in")
            return
        }

        // Listen for real-time updates to the SOS profile
        self.listener = self.firebaseFirestore.collection("sos")
            .document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching SOS profile: \(error.localizedDescription)")
                    return
                }

                guard let documentSnapshot = documentSnapshot else {
                    print("Document snapshot is empty")
                    return
                }

                do {
                    let sosProfile = try documentSnapshot.data(as: Sos.self)
                    self.sosProfile = sosProfile
                } catch {
                    print("Error decoding SOS profile: \(error)")
                }
            }
    }

    /// Delete the SOS profile of the currently signed-in user.
    func deleteSosProfile() {
        guard let userId = self.firebaseAuthntication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        firebaseFirestore.collection("sos").document(userId).delete { error in
            if let error = error {
                print("Failed to delete SOS profile from Firestore: \(error.localizedDescription)")
            } else {
                self.sosProfile = nil
                print("SOS profile successfully deleted.")
            }
        }
    }

    /// Save the user's profile image to Core Data.
    func saveProfileImage(image: UIImage) {
        guard let userID = firebaseAuthntication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        let context = PersistentStore.shared.context
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let results = try context.fetch(fetchRequest)
            let userProfile: UserProfile

            if results.isEmpty {
                // Create a new UserProfile entity if none exists
                userProfile = UserProfile(context: context)
                userProfile.userID = userID
            } else {
                // Use the existing UserProfile entity
                userProfile = results.first!
            }

            // Save the profile image as PNG data
            userProfile.profileImage = image.pngData()
            PersistentStore.shared.save()

            // Ensure updates to @Published properties are on the main thread
            DispatchQueue.main.async {
                self.profileImage = image
            }
        } catch {
            print("Failed to save profile image: \(error.localizedDescription)")
        }
    }

    /// Load the user's profile image from Core Data.
    func loadProfileImage() {
        guard let userID = firebaseAuthntication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        let context = PersistentStore.shared.context
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let results = try context.fetch(fetchRequest)
            if let userProfile = results.first, let imageData = userProfile.profileImage {
                // Convert PNG data back to UIImage
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: imageData)
                }
            } else {
                // No profile image found for this user
                DispatchQueue.main.async {
                    self.profileImage = nil
                }
            }
        } catch {
            print("Failed to load profile image: \(error.localizedDescription)")
        }
    }
    
    /// Compress the image to ensure it's under 100KB.
    private func compressImage(_ image: UIImage, targetSizeKB: Int = 100) -> Data? {
        let maxSize = targetSizeKB * 1024 // 100KB in bytes
        var compressionQuality: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        while imageData?.count ?? 0 > maxSize && compressionQuality > 0 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
        
        // Additional step to check if the image needs to be resized
        if imageData?.count ?? 0 > maxSize {
            // Resize image to further reduce size
            if let resizedImage = resizeImage(image, maxSizeKB: targetSizeKB) {
                imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
            }
        }
        
        return imageData
    }
    
    /// Resize image to ensure it is under the maximum file size.
    private func resizeImage(_ image: UIImage, maxSizeKB: Int) -> UIImage? {
        let maxSize = maxSizeKB * 1024 // 100KB in bytes
        var originalSize = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        
        if originalSize <= maxSize {
            return image
        }
        
        var newSize = image.size
        var _: CGFloat = max(newSize.width, newSize.height)
        
        while originalSize > maxSize {
            let scaleFactor = sqrt(CGFloat(maxSize) / CGFloat(originalSize))
            newSize.width *= scaleFactor
            newSize.height *= scaleFactor
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resizedImageData = resizedImage?.jpegData(compressionQuality: 1.0) {
                originalSize = resizedImageData.count
                if originalSize <= maxSize {
                    return resizedImage
                }
            }
        }
        
        return nil
    }
    
    /// Upload the user's profile image to Firebase Storage.
    func uploadProfileImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let userID = firebaseAuthntication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        // Create a reference to the Firebase Storage
        let storageRef = firebaseStorage.reference().child("profile_images/\(userID).png")
        
        // Compress the image
        guard let imageData = compressImage(image) else {
            print("Failed to compress image.")
            return
        }

        // Upload the image data to Firebase Storage
        _ = storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                // Get the download URL for the uploaded image
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
