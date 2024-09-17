//
//  SosView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import SwiftUI
import PassKit

/// View to display and manage the user's SOS profile.
struct SosView: View {

    @ObservedObject var profileViewModel: ProfileViewModel // ViewModel for managing SOS profile data
    @State private var showSosSheet: Bool = false // State to control the visibility of the edit sheet

    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view

    var body: some View {
        NavigationStack {
            VStack {
                // Check if SOS profile data is available
                if profileViewModel.sosProfile != nil {
                    Form {
                        // Sections to display various parts of the SOS profile
                        personalInformationSection
                        if !(profileViewModel.sosProfile?.emergencyContacts.isEmpty ?? true) {
                            emergencyContactsSection
                        }
                        medicalInformationSection
                        addressSection
                        deleteSection
                    }
                } else {
                    // Message displayed if no SOS profile data is available
                    Text("No SOS Data available.")
                        .foregroundColor(.gray)
                        .bold()
                        .padding()
                }
            }
            .navigationTitle("SOS Profile") // Title for the navigation bar
            .navigationBarItems(trailing: editButton) // Button to trigger the edit sheet
            .sheet(isPresented: $showSosSheet) {
                // Display the sheet for editing SOS profile
                SosSheetView(profileViewModel: profileViewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    /// Section displaying personal information from the SOS profile.
    private var personalInformationSection: some View {
        Section("Personal Information") {
            HStack {
                Text("Blood Type") // Label for blood type
                Spacer()
                Text(profileViewModel.sosProfile?.bloodType ?? "")
                    .foregroundColor(.gray) // Display blood type or empty string if not available
            }
        }
    }

    /// Section displaying emergency contacts from the SOS profile.
    private var emergencyContactsSection: some View {
        Section("Emergency Contacts") {
            // Display each emergency contact in the SOS profile
            ForEach(profileViewModel.sosProfile?.emergencyContacts ?? []) { contact in
                VStack {
                    contactInfoRow(label: "Name:", value: contact.name)
                    contactInfoRow(label: "Phone Number:", value: contact.phone)
                    contactInfoRow(label: "Relationship:", value: contact.relationship)
                }
            }
        }
    }

    /// Helper function to create a row displaying contact information.
    private func contactInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label) // Label for the contact info
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray) // Display contact info value
        }
    }

    /// Section displaying medical information from the SOS profile.
    private var medicalInformationSection: some View {
        Section("Medical Information") {
            HStack {
                Text("Conditions") // Label for medical conditions
                Spacer()
                Text(profileViewModel.sosProfile?.medicalConditions ?? "")
                    .foregroundColor(.gray) // Display medical conditions or empty string if not available
            }
            HStack {
                Text("Allergies") // Label for allergies
                Spacer()
                Text(profileViewModel.sosProfile?.allergies ?? "")
                    .foregroundColor(.gray) // Display allergies or empty string if not available
            }
        }
    }

    /// Section displaying address information from the SOS profile.
    private var addressSection: some View {
        Section(header: Text("Address")) {
            if let address = profileViewModel.sosProfile?.address {
                VStack(alignment: .leading) {
                    addressRow(label: "Street Name:", value: address.streetName)
                    addressRow(label: "Street Number:", value: address.streetNumber)
                    addressRow(label: "City:", value: address.city)
                    addressRow(label: "State:", value: address.state)
                    addressRow(label: "Zip Code:", value: address.zipCode)
                    addressRow(label: "Country:", value: address.country)
                }
            }
        }
    }

    /// Helper function to create a row displaying address information.
    private func addressRow(label: String, value: String) -> some View {
        HStack {
            Text(label) // Label for address info
            Spacer()
            Text(value)
                .foregroundColor(.gray) // Display address info value
        }
    }

    /// Section with a button to delete the SOS profile data.
    private var deleteSection: some View {
        Section {
            HStack {
                Spacer()
                Button(action: {
                    profileViewModel.deleteSosProfile() // Delete the SOS profile
                    dismiss() // Dismiss the view
                }) {
                    Text("Delete SOS Data")
                        .foregroundColor(.red) // Red color for delete action
                }
                Spacer()
            }
        }
    }

    /// Button to trigger the edit sheet for the SOS profile.
    private var editButton: some View {
        Button(action: {
            showSosSheet = true // Show the sheet for editing SOS profile
        }) {
            Text("Edit")
                .foregroundColor(.appYellow) // Yellow color for edit button
        }
    }
}
