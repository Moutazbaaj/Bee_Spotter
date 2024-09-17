//
//  Address.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
struct Address: Codable, Identifiable {
    var id = UUID()
    var streetName: String
    var streetNumber: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
}
