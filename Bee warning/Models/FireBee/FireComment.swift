//
//  FireComment.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 16.07.24.
//

import Foundation
import FirebaseFirestore

// Model representing a comment associated with a bee report in Firebase Firestore.
struct FireComment: Identifiable, Codable {
    
    @DocumentID var id: String?     // Unique ID for each comment, automatically generated by Firestore.
    var userId: String     // ID of the user who posted the comment.
    var beeId: String     // ID of the bee report this comment is associated with.
    var username: String     // Username of the user who posted the comment.
    var text: String     // Text content of the comment.
    var timestamp: Timestamp     // Timestamp of when the comment was posted, stored as a Firestore Timestamp.
    var color: String     // Color associated with the comment, which could be used for UI customization.
    
}
