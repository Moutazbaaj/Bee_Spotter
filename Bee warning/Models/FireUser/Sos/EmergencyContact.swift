//
//  EmergencyContact.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
struct EmergencyContact: Codable, Identifiable {
    var id = UUID()
    var name: String
    var phone: String
    var relationship: String
}
