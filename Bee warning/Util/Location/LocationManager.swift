//
//  LocationManager.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI
import CoreLocation

// Observable class to manage location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()  // CLLocationManager instance

    @Published var userLocation: CLLocation?    // Stores the user's current location
    @Published var heading: CLLocationDirection? // Stores the user's current heading
    @Published var isAuthorized = false         // Indicates if location services are authorized

    // Initializer
    override init() {
        super.init()
        manager.delegate = self       // Set the delegate to self
        startLocationServices()       // Start location services
    }

    // Function to start location services
    func startLocationServices() {
        // Check if location services are authorized
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()  // Start updating location
            manager.startUpdatingHeading()   // Start updating heading
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestAlwaysAuthorization()  // Request always authorization
        }
    }

    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last  // Update userLocation with the last location
    }

    // CLLocationManagerDelegate method to handle heading updates
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading.isNaN ? newHeading.magneticHeading : newHeading.trueHeading
    }

    // CLLocationManagerDelegate method to handle authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()  // Request the current location
        case .notDetermined:
            isAuthorized = false
            manager.requestAlwaysAuthorization()  // Request always authorization
        case .denied:
            isAuthorized = false
            print("Access denied")
        default:
            isAuthorized = true
            startLocationServices()    // Restart location services
        }
    }

    // CLLocationManagerDelegate method to handle location update failures
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)  // Print error description
    }
}
