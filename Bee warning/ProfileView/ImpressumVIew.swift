//
//  ImpressumView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 24.07.24.
//

import SwiftUI

struct ImpressumView: View {
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
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Spacer()
                            ZStack {
                                // Outer circle with shadow
                                Circle()
                                    .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                    .foregroundColor(.appYellow) // The color of the circle
                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                    .frame(width: 220, height: 220)
                                Image("beeLogo")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .padding()
                            }
                            Spacer()
                        }
                        
                        Group {
                            Text("App Information")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                                .padding(.bottom, 5)
                            
                            Text("Bee-Spotter is an app that allows users to track and report bee sightings, contributing to citizen science efforts while helping individuals stay aware of bee activity in their area. The app includes real-time notifications, statistical data, and detailed information about various bee species.")
                                .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                        Divider()
                            .background(Color.appYellow)
                        
                        Group {
                            Text("Privacy Policy")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                                .padding(.bottom, 5)
                            
                            Text("Bee-Spotter respects your privacy and does not collect unnecessary personal data. Your location is only used for reporting sightings and is never shared with third parties. You can manage your data and delete reports at any time.")
                                .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                        Divider()
                            .background(Color.appYellow)
                        
                        Group {
                            Text("Developer Information")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                                .padding(.bottom, 5)
                            
                            HStack {
                                Text("Name:")
                                    .bold()
                                Spacer()
                                Text("Moutaz Baaj")
                            }
                            .padding(.vertical, 5)
                            
                            HStack {
                                Text("GitHub:")
                                    .bold()
                                Spacer()
                                Link("https://github.com/Moutazbaaj", destination: URL(string: "https://github.com/Moutazbaaj")!)
                                    .foregroundColor(.appYellow)
                            }
                            .padding(.vertical, 5)
                            
                            HStack {
                                Text("Email:")
                                    .bold()
                                Spacer()
                                Link("moutazbaaj@gmail.com", destination: URL(string: "mailto:moutazbaaj@gmail.com")!)
                                    .foregroundColor(.appYellow)
                            }
                            .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                        Divider()
                            .background(Color.appYellow)
                        
                        Group {
                            Text("Copyright & Legal")
                                .font(.title2)
                                .foregroundColor(.appYellow)
                                .padding(.bottom, 5)
                            
                            Text("© 2024 Moutaz Baaj. All rights reserved. Unauthorized distribution or use of this app is prohibited. Bee-Spotter and its content are protected by copyright laws and intellectual property rights.")
                                .padding(.vertical, 5)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                        .foregroundColor(.white)

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("About Us")
        }
        .foregroundColor(.black)
    }
}

// Preview
#Preview {
    ImpressumView()
        .environmentObject(LocationManager())
}
