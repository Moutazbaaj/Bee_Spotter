//
//  Bee_warningApp.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI
import Firebase

@main
struct Bee_warningApp: App { // swiftlint:disable:this type_name
    @StateObject private var authViewModel = AuthViewModel()  // Shared instance of AuthViewModel
    @StateObject private var locationManager = LocationManager()  // Shared instance of LocationManager
    @StateObject private var notificationManger = NotificationManger()  // Shared instance of NotificationManager
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var selectedBee: FireBee?
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainContentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(authViewModel)
                    .environmentObject(locationManager)
                    .environmentObject(notificationManger)

            }
            .preferredColorScheme(.dark) // Force dark mode
        }
    }
}
