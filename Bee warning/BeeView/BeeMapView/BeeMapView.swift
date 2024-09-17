//
//  BeeMapView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

/// View to display the map with bee annotations and user interface elements.
struct BeeMapView: View {
    
    @StateObject private var beeViewModel = BeeViewModel.shared  // ViewModel for managing bees
    @StateObject private var profileViewModel = ProfileViewModel.shared  // ViewModel for showing the profile image
    
    @EnvironmentObject var authViewModel: AuthViewModel  // Environment object for managing user data
    @EnvironmentObject var locationManager: LocationManager  // Environment object for location management
    
    @State private var isInitialLaunch: Bool = true  // State to track the initial launch of the view
    @State private var showBeeReportSheet: Bool = false  // State to control the visibility of the bee report sheet
    @State private var is3DView: Bool = true  // State to control the 2-D or 3-D view of the map
    @State private var selectedBee: FireBee?  // State to store the selected bee for detailed view
    @State private var cameraPosition: MapCameraPosition = .automatic  // State to manage the camera position on the map
    @State private var showWelcomeMessage = true // State to control the visibility of the welcome message
    @State private var opacity: Double = 1.0 // State to control the opacity for fade-out animation
    
    @State private var imageOffset: CGFloat = UIScreen.main.bounds.width // Start position off-screen
    @State private var bounce: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map view with bee annotations and user location
                Map(position: $cameraPosition) {
                    
                    UserAnnotation()  // Annotation for user location
                    
                    // Add annotations for each bee
                    ForEach(beeViewModel.bees) { bee in
                        Annotation("\(bee.title)\n-\n'\(bee.kind)'", coordinate: CLLocationCoordinate2D(latitude: bee.location.latitude, longitude: bee.location.longitude)) {
                            NavigationLink(destination: BeeReportDetailsView(beeViewModel: beeViewModel, bee: bee)) {
                                Image("beeLogo")
                                    .resizable()
                                    .frame(width: 40, height: 40)  // Resizable bee logo image
                            }
                        }
                    }
                }
                .onAppear {
                    if isInitialLaunch {
                        updateCameraPosition()  // Update camera position on the first launch
                        isInitialLaunch = false
                    }
                    beeViewModel.fetchBees()  // Fetch bees from the view model
                    if let userLocation = locationManager.userLocation {
                        beeViewModel.updateNearbyBeesCounts(userLocation: userLocation)  // Update nearby bees count based on user location
                    }
                    profileViewModel.loadProfileImage()  // Load profile image from the view model
                    
                    // Trigger fade-out after 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeOut(duration: 2)) {
                            opacity = 0.0 // Start fade-out animation
                        }
                        
                        // After the fade-out completes, hide the message completely
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showWelcomeMessage = false
                        }
                    }
                }
                .mapControls {
                    VStack {
                        MapUserLocationButton()  // Button to center the map on user location
                        MapCompass()  // Compass for map orientation
                        MapPitchToggle()  // Toggle for changing map pitch
                        MapScaleView()
                    }
                    .padding()
                }
                
                VStack {
                    
                    VStack {
                        // Display the welcome message with fade-out animation
                        if showWelcomeMessage {
                            VStack {
                                Text("Welcome!")
                                    .font(.callout)
                                    .foregroundColor(.black)
                                    .shadow(radius: 10)
                                    .fontWeight(.bold)
                                    .padding(2)
                                    .opacity(opacity) // Bind opacity to control fade-out
                                    .transition(.opacity) // Smoothly transition the appearance/disappearance
//                                Text(authViewModel.user?.username ?? "Unknown")
//                                    .font(.callout)
//                                    .shadow(color: .appYellow, radius: 0.5)
//                                    .foregroundColor(.black)
//                                    .shadow(radius: 10)
//                                    .fontWeight(.bold)
//                                    .opacity(opacity) // Bind opacity to control fade-out
//                                    .transition(.opacity) // Smoothly transition the appearance/disappearance
//                                    .padding(2)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.appYellow)
                                    .shadow(radius: 10)
                                    .opacity(opacity) // Bind opacity to control fade-out
                                    .transition(.opacity) // Smoothly transition the appearance/disappearance
                            )
                            
                            Image("beeLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .offset(x: imageOffset, y: bounce ? -30 : 30) // Apply bounce effect
                                .opacity(opacity) // Bind opacity to control fade-out
                                .transition(.opacity) // Smoothly transition the appearance/disappearance
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(0.5), value: bounce
                                )
                                .onAppear {
                                    // Start animation
                                    bounce.toggle()
                                    withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: false)) {
                                        imageOffset = -UIScreen.main.bounds.width // Move image to off-screen left
                                    }
                                }
                            
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Bottom buttons for actions
                    HStack {
                        // Button to show bee report sheet
                        Button(action: { showBeeReportSheet = true }) {
                            Image(systemName: "plus.square.fill.on.square.fill")
                                .font(.callout)
                                .foregroundColor(.appYellow)
                                .fontWeight(.bold)
                                .padding()
                                .background(
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                            .opacity(0.8)
                                            .frame(width: geometry.size.width, height: geometry.size.height )
                                    }
                                )
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showBeeReportSheet) {
                            BeeReportSheetView(beeViewModel: beeViewModel, locationManager: _locationManager)
                                .presentationDetents([.large])
                        }
                        
                        // Toggle button for 2-D and 3-D view
                        Button(action: {
                            is3DView.toggle()
                            updateCameraPosition()  // Update camera position when toggling view
                        }) {
                            Image(systemName: is3DView ? "minus.magnifyingglass" : "plus.magnifyingglass")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding()
                                .background(
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                            .opacity(0.8)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                )
                        }
                        .padding()
                    }
                }
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea(.all)  // Ignore safe area to extend the map view
    }
    
    /// Updates the camera position based on the user's location and view mode (2-D or 3-D).
    private func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let heading = locationManager.heading ?? 0.0
            let distance = is3DView ? 400.0 : 800.0
            let pitch = is3DView ? 70.0 : 0.0
            let camera = MapCamera(centerCoordinate: userLocation.coordinate, distance: distance, heading: heading, pitch: pitch)
            
            withAnimation {
                cameraPosition = .camera(camera)
            }
        }
    }
}
