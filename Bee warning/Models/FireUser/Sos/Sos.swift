//
//  Sos.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
struct Sos: Codable, Identifiable {

    let id: String               // Unique identifier for the user
    var bloodType: String        // Blood type of the user
    var username: String         // Username chosen by the user
    var birthday: Date           // Birthday of the user
    let registeredAt: Date       // Date when the user registered
    var emergencyContacts: [EmergencyContact] // List of emergency contacts
    var medicalConditions: String // List of medical conditions
    var allergies: String      // List of allergies
    var address: Address         // Address of the user
}
