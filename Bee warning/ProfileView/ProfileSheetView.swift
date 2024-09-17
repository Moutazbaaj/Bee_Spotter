//
//  ProfileSheetView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 30.06.24.
//

import SwiftUI
import PhotosUI

// View for editing the user's profile details in a sheet
struct ProfileSheetView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var profileViewModel = ProfileViewModel.shared
    
    @Binding var newUsername: String
    @Binding var newBirthday: Date
    @Binding var showSettingSheet: Bool
    @Binding var selectedColor: Color
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showAlert = false // State to control the alert visibility
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .foregroundColor(.appYellow)
                                    .shadow(color: .white, radius: 10)
                                    .frame(width: 220, height: 220)
                                if let profileImage = profileViewModel.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .padding()
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .padding()
                                }
                            }
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                    .background(Color.black)
                                    .foregroundStyle(.appYellow)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                    .padding()
                            }
                            .onChange(of: selectedItem) { _, newItem in
                                if let newItem = newItem {
                                    newItem.loadTransferable(type: Data.self) { result in
                                        switch result {
                                        case .success(let data):
                                            if let data = data, let uiImage = UIImage(data: data) {
                                                selectedImage = uiImage
                                                profileViewModel.saveProfileImage(image: uiImage)
                                                profileViewModel.uploadProfileImage(image: uiImage) { result in
                                                    switch result {
                                                    case .success(let url):
                                                        print("Image uploaded successfully. Download URL: \(url)")
                                                    case .failure(let error):
                                                        print("Failed to upload image: \(error.localizedDescription)")
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print("Failed to load image: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }
                        //                    Form {
                        //                        Section {
                        TextField("Username", text: $newUsername)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .submitLabel(.done)
                            .onChange(of: newUsername) {_, newValue in
                                if newValue.count > 20 {
                                    newUsername = String(newValue.prefix(20)) // Limit to 20 characters
                                    showAlert = true // Show the alert if the limit is exceeded
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Character Limit Exceeded"),
                                    message: Text("Username cannot exceed 20 characters."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        
                        DatePicker("Birthday:", selection: $newBirthday, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(.vertical)
                            .foregroundColor(.white)
                        
                        ColorPicker("Profile Color Tag", selection: $selectedColor)
                            .padding(.vertical)
                            .foregroundColor(.white)
                        //                        }
                        //                    }
                        //                    .scrollContentBackground(.hidden)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                authViewModel.updateUser(username: newUsername, birthday: newBirthday, color: selectedColor.description)
                                print("User data updated")
                                showSettingSheet = false
                            }) {
                                Text("Save Changes")
                                    .padding()
                                    .foregroundColor(.appYellow)
                                    .background(Color.black)
                                    .cornerRadius(15)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Profile Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        showSettingSheet = false
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

// Preview
#Preview {
    ProfileSheetView(
        authViewModel: AuthViewModel(),
        newUsername: .constant("JohnDoe"),
        newBirthday: .constant(Date()),
        showSettingSheet: .constant(true),
        selectedColor: .constant(.yellow)
    )
}
