//
//  SosSheetView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import SwiftUI

/// View for editing or creating an SOS profile.
struct SosSheetView: View {
    @ObservedObject var profileViewModel: ProfileViewModel // ViewModel to manage the SOS profile data

    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view

    // State variables to hold the form data
    @State private var bloodType: String = ""
    @State private var emergencyContacts: [EmergencyContact] = []
    @State private var medicalConditions: String = ""
    @State private var allergies: String = ""
    @State private var address: Address = Address(streetName: "", streetNumber: "", city: "", state: "", zipCode: "", country: "")

    @State private var showAlert = false // State to control the visibility of alerts
    @State private var alertMessage = "" // State to store the alert message

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Blood Type")) {
                    TextField("Blood Type", text: $bloodType)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Styled text field for blood type
                }

                emergencyContactsSection
                medicalConditionsSection
                allergiesSection
                addressSection
                
                HStack {
                    Spacer()
                    Button(action: saveProfile) {
                        Text("Save")
                            .foregroundStyle(.appYellow) // Button to save profile data
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Edit SOS Profile", displayMode: .inline) // Title for the navigation bar
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss() // Action to dismiss the view
            }
                .foregroundStyle(.appYellow)
            )
            .onAppear(perform: loadProfile) // Load profile data when the view appears
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage == "SOS profile saved successfully." {
                    dismiss() // Dismiss the view if profile is saved successfully
                }
            })
        }
    }

    /// Section to manage emergency contacts in the form.
    private var emergencyContactsSection: some View {
        Section(header: Text("Emergency Contacts")) {
            // Display each emergency contact with editable fields
            ForEach($emergencyContacts, id: \.id) { $contact in
                VStack {
                    TextField("Name", text: $contact.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Name field
                    TextField("Phone", text: $contact.phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Phone field
                    TextField("Relationship", text: $contact.relationship)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Relationship field
                }
            }
            Button(action: addEmergencyContact) {
                Text("Add Contact")
                    .foregroundStyle(.appYellow) // Button to add a new emergency contact
            }
        }
    }

    /// Section to manage medical conditions in the form.
    private var medicalConditionsSection: some View {
        Section(header: Text("Medical Conditions")) {
            TextField("Condition", text: $medicalConditions)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Field for medical conditions
        }
    }

    /// Section to manage allergies in the form.
    private var allergiesSection: some View {
        Section(header: Text("Allergies")) {
            TextField("Allergy", text: $allergies)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Field for allergies
        }
    }

    /// Section to manage address information in the form.
    private var addressSection: some View {
        Section(header: Text("Address")) {
            TextField("Street Name", text: $address.streetName)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Street Name field
            TextField("Street Number", text: $address.streetNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Street Number field
            TextField("City", text: $address.city)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // City field
            TextField("State", text: $address.state)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // State field
            TextField("Zip Code", text: $address.zipCode)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Zip Code field
            TextField("Country", text: $address.country)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Country field
        }
    }

    /// Adds a new emergency contact to the list.
    private func addEmergencyContact() {
        emergencyContacts.append(EmergencyContact(name: "", phone: "", relationship: ""))
    }

    // These functions for adding new medical conditions and allergies are not used in the current implementation
    private func addMedicalCondition() {
        medicalConditions.append("")
    }

    private func addAllergy() {
        allergies.append("")
    }

    /// Loads the SOS profile data into the form fields when the view appears.
    private func loadProfile() {
        if let sosProfile = profileViewModel.sosProfile {
            bloodType = sosProfile.bloodType
            emergencyContacts = sosProfile.emergencyContacts
            medicalConditions = sosProfile.medicalConditions
            allergies = sosProfile.allergies
            address = sosProfile.address
        }
    }

    /// Saves the SOS profile data and shows an alert if successful.
    private func saveProfile() {
        let missingFields = getMissingFields() // Get any missing required fields
        if missingFields.isEmpty {
            profileViewModel.createUserSosProfile(
                id: profileViewModel.user?.id ?? UUID().uuidString,
                bloodType: bloodType,
                username: profileViewModel.user?.username ?? "",
                birthday: profileViewModel.user?.birthday ?? Date(),
                emergencyContacts: emergencyContacts,
                medicalConditions: medicalConditions,
                allergies: allergies,
                address: address
            )
            alertMessage = "SOS profile saved successfully."
            showAlert = true // Show success alert
        } else {
            alertMessage = "Please fill in the following fields: \(missingFields.joined(separator: ", "))"
            showAlert = true // Show error alert with missing fields
        }
    }

    /// Checks which required fields are missing.
    private func getMissingFields() -> [String] {
        var missingFields: [String] = []
        func checkEmpty(_ field: String, _ label: String) {
            if field.isEmpty {
                missingFields.append(label)
            }
        }
        // Check for blood type
        checkEmpty(bloodType, "Blood Type")
        // Check emergency contacts
        for (index, contact) in emergencyContacts.enumerated() {
            checkEmpty(contact.name, "\(index + 1).Emergency Contact Name")
            checkEmpty(contact.phone, "\(index + 1).Emergency Contact Phone")
            checkEmpty(contact.relationship, "\(index + 1).Emergency Contact Relationship")
        }
        // Check medical conditions and allergies
        checkEmpty(medicalConditions, "Medical Conditions")
        checkEmpty(allergies, "Allergies")
        // Check address fields
        checkEmpty(address.streetName, "Street Name")
        checkEmpty(address.streetNumber, "Street Number")
        checkEmpty(address.city, "City")
        checkEmpty(address.state, "State")
        checkEmpty(address.zipCode, "Zip Code")
        checkEmpty(address.country, "Country")
        return missingFields
    }
}

// struct SosSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SosSheetView(profileViewModel: ProfileViewModel())
//    }
// }
