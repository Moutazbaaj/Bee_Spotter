//
//  LocationDeniedView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 30.06.24.
//

import SwiftUI

// View to display instructions when location services are denied
struct LocationDeniedView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient color
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Image("beeLogo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding()
                        
                        Spacer()
                        Spacer()

                        // Title
                        Text("Location Services is nedded!")
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                        // Instruction text
                        Text("""
                        To use the App You need to allow the acsses to the "Location Services"
                        
                        1. Tap the button below to open the app settings.
                        
                        2. Change the location access to "Always" and activate the "Precise Location" if the Option is disable .
                        """)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .padding()
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                      options: [:],
                                                      completionHandler: nil)
                        }) {
                            Text("Open Settings")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.appYellow)
                                .cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LocationDeniedView()
}
