//
//  LocationImage.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 02.07.24.
//

import Foundation

// Struct to represent a location image fetched from Google Street View API
struct LocationImage {

    let imageData: Data      // The image data of the location
    let latitude: Double     // The latitude of the location
    let longitude: Double    // The longitude of the location
    let size: String         // The size of the image
}
