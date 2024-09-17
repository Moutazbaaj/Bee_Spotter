//
//  BeeReportSheetView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 30.06.24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct BeeReportSheetView: View {
    @ObservedObject var beeViewModel: BeeViewModel
    @StateObject private var reportsViewModel = ReportsViewModel.shared // ViewModel for managing reports
    @EnvironmentObject var authViewModel: AuthViewModel // Environment object for managing user data
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location = GeoPoint(latitude: 0.00, longitude: 0.00)
    @State private var kind = BeeKind.other
    @State private var address: String = "unknown Location"
    @State private var isFetchingAddress: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    Text("Report a Bee")
                        .bold()
                        .padding()
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        // Title Input
                        Text("Title")
                            .foregroundStyle(.black)

                        TextField("", text: $title)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding(.bottom)
                            .submitLabel(.done)

                        Text("Provide a brief and descriptive title to help identify the issue.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.bottom)

                        // Description Input
                        Text("Description")
                            .foregroundStyle(.black)

                        TextField("", text: $description)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding(.bottom)
                            .submitLabel(.done)

                        Text("Description helps in understanding the context and severity.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.bottom)

                        Divider()

                        // Bee Type Selection
                        Text("Bee type")
                            .foregroundStyle(.black)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(BeeKind.allCases, id: \.self) { beeKind in
                                    Button(action: {
                                        kind = beeKind
                                    }) {
                                        VStack {
                                            ZStack {
                                                // Outer circle with shadow
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(lineWidth: 2) // Adjust the thickness of the circle
                                                    .foregroundColor(.appYellow) // The color of the circle
//                                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                                    .frame(width: 115, height: 115)

                                                Image(beeKind.imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    .shadow(radius: 10)
                                                    .opacity(kind == beeKind ? 0.2 : 1.0) // Highlight selected item
                                            }
                                            Text(beeKind.rawValue)
                                                .font(.caption)
                                                .foregroundColor(kind == beeKind ? .appYellow : .white)
                                        }
                                        .padding(4)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                        
                        Text("Select the type of bee if you know it. If unsure, choose 'Other'.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Divider()
                        // Save Button
                        HStack {
                            Spacer()
                            Button("Save") {
                                saveReport()
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.appYellow)
                            .cornerRadius(15)
                            .disabled(title.isEmpty || description.isEmpty)
                            Spacer()
                        }
                        .padding()
                    }
                    .padding()
                    .onAppear {
                        updateLocationAndAddress()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
        .foregroundColor(.black)
    }

    // Function to update location and address when the view appears
    private func updateLocationAndAddress() {
        if let currentLocation = locationManager.userLocation {
            location = GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            fetchLocationDetails()
        } else {
            address = "Location not available"
        }
    }

    // Fetching the address for the current location
    private func fetchLocationDetails() {
        isFetchingAddress = true
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        beeViewModel.reverseGeocode(location: location) { fetchedAddress in
            DispatchQueue.main.async {
                self.address = fetchedAddress
                isFetchingAddress = false
            }
        }
    }

    // Save the report with the updated information
    private func saveReport() {
        beeViewModel.createBee(userName: authViewModel.user?.username ?? "unknown", title: title, description: description, address: address, location: location, kind: kind.rawValue)
        reportsViewModel.createReportItem(userName: authViewModel.user?.username ?? "unknown", title: title, description: description, location: location, kind: kind.rawValue)
        dismiss()
    }
}

// Preview
struct BeeReportSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BeeReportSheetView(
            beeViewModel: BeeViewModel()
        )
        .environmentObject(LocationManager())
        .environmentObject(AuthViewModel())
    }
}
