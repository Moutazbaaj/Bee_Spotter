//
//  MapImageViewModel.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 02.07.24.
//

import Foundation
import UIKit

@MainActor
class MapImageViewModel: ObservableObject {

    // singleton shared for the viewModel
    static let shared = MapImageViewModel()

    // Published properties to handle UI updates
    @Published var locationImage: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Repository to handle data retrieval
    private let repository = MapImageRepository()

    // Method to fetch location image asynchronously
    func fetchLocationImage(latitude: Double, longitude: Double) {
        // Set loading state and clear previous error message
        isLoading = true
        errorMessage = nil

        // Perform asynchronous task using Swift's concurrency model
        Task {
            do {
                // Call repository method to fetch image data
                let locationImage = try await repository.fetchLocationImage(latitude: latitude, longitude: longitude)

                // Convert fetched data to UIImage
                if let image = UIImage(data: locationImage.imageData) {
                    self.locationImage = image
                } else {
                    // Set error message if image data could not be converted to UIImage
                    self.errorMessage = "Failed to decode image"
                }
            } catch {
                // Set error message for any errors that occur during image fetching
                self.errorMessage = "Error fetching location image: \(error.localizedDescription)"
                print("Error fetching location image: \(error.localizedDescription)")
            }

            // Set loading state to false after async task completes
            self.isLoading = false
        }
    }
}
