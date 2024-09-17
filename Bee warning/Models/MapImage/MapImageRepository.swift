//
//  MapImageRepository.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 02.07.24.
//

import Foundation

// Class to handle fetching location images from Google Street View API
class MapImageRepository {

    // Enum to represent API status and errors
    enum ApiStatus: Error {
        case invalidURL         // Error case for invalid URL
        case validResponse      // Error case for invalid response
    }

    // Base URL for Google Street View API
    private let baseUrl = "https://maps.googleapis.com/maps/api/streetview"

    // Function to fetch location image using latitude, longitude, and size
    // Parameters:
    // - latitude: The latitude of the location
    // - longitude: The longitude of the location
    // - size: The size of the image to be fetched (default set at: "800x400")
    // Returns: LocationImage object with fetched image data and location details
    func fetchLocationImage(latitude: Double, longitude: Double, size: String = "800x400") async throws -> LocationImage {
        // Construct URL components from base URL
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw ApiStatus.invalidURL    // Throw error if URL is invalid
        }

        // Set query items for URL components
        urlComponents.queryItems = [
            URLQueryItem(name: "size", value: size),
            URLQueryItem(name: "location", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "fov", value: "90"),
            URLQueryItem(name: "heading", value: "235"),
            URLQueryItem(name: "pitch", value: "10"),
            URLQueryItem(name: "key", value: ApiKey.shared.apiKey)  // API key from shared instance
        ]

        // Construct final URL from URL components
        guard let url = urlComponents.url else {
            throw ApiStatus.invalidURL    // Throw error if URL construction fails
        }

        // Perform network request to fetch data and response
        let (data, response) = try await URLSession.shared.data(from: url)

        // Debugging: Print URL and response status
        print("URL: \(url)")
        print("Response: \(response)")

        // Validate HTTP response status code
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiStatus.validResponse // Throw error if response is not valid
        }

        // Return LocationImage object with fetched data and location details
        return LocationImage(imageData: data, latitude: latitude, longitude: longitude, size: size)
    }
}
