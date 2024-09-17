//
//  BeeLocationInfoSheet.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 08.08.24.
//

import SwiftUI
import CoreLocation
import MapKit

struct BeeReportInfoSheet: View {
    @ObservedObject var beeViewModel: BeeViewModel
    var bee: FireBee
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var address: String = "Fetching address..."
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var isInitialLaunch: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Reported on:")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding()
                        Text(bee.timestamp.dateValue(), style: .date)
                            .font(.callout)
                        Text(bee.timestamp.dateValue(), style: .time)
                            .font(.callout)
                    }
                    
                    Divider()
                    
                    if bee.editTimestamp != nil {
                        
                        HStack {
                            Text("Edited at:")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .padding()
                            Text(bee.editTimestamp!.dateValue(), style: .date)
                                .font(.callout)
                                .foregroundStyle(.gray)

                            Text(bee.editTimestamp!.dateValue(), style: .time)
                                .font(.callout)
                                .foregroundStyle(.gray)

                        }
                        
                        Divider()
                    }
                    
                    HStack {
                        Text("Report will be Deleted in:")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding()
                        Text(beeViewModel.timeString(from: beeViewModel.remainingTime))
                            .font(.callout)
                            .foregroundColor(beeViewModel.remainingTime <= 60 ? .red : .green)
                        Text("HH:MM:SS")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Address:")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding()
                        
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()

                    }
                    
                    Divider()
                    
                    HStack {
                        Text("coords:")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding()
                        
                        Text("Latitude: \(bee.location.latitude)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("Longitude: \(bee.location.longitude)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Divider()

                    ZStack {
                        Map(position: $cameraPosition) {
                            Annotation(bee.title, coordinate: CLLocationCoordinate2D(latitude: bee.location.latitude, longitude: bee.location.longitude)) {
                                VStack {
                                    Image("beeLogo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                        .onAppear {
                            if isInitialLaunch {
                                updateCameraPosition()
                                isInitialLaunch = false
                            }
                        }
                        
                        // Transparent overlay to block user interactions
                        Color.black.opacity(0.00001)
                    }
                }
                .padding()
                .onAppear {
                    fetchLocationDetails()
                }
            }
            .padding()
            .navigationTitle("Report Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            }
                .foregroundStyle(.appYellow)
            )
        }
    }
    
    private func fetchLocationDetails() {
        let location = CLLocation(latitude: bee.location.latitude, longitude: bee.location.longitude)
        beeViewModel.reverseGeocode(location: location) { fetchedAddress in
            DispatchQueue.main.async {
                self.address = fetchedAddress
            }
        }
    }
    
    private func updateCameraPosition() {
        let location = CLLocationCoordinate2D(latitude: bee.location.latitude, longitude: bee.location.longitude)
        
        let camera = MapCamera(centerCoordinate: location, distance: 300, heading: 0.0, pitch: 0.0)
        
        withAnimation {
            cameraPosition = .camera(camera)
        }
    }
}
