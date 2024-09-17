//
//  BeeKindDetailView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 05.07.24.
//

import SwiftUI

// A view to display detailed information about a specific bee kind.
struct BeeKindDetailView: View {
    
    @Environment(\.dismiss) private var dismiss

    // The bee kind to display.
    var beeKind: BeeKind
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // Display the image of the bee kind.
                        Image(beeKind.imageName)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 15)
                            .padding(4)
                            .background(Color.black.opacity(0.3)) // Slight dark background for the image
                            .clipShape(RoundedRectangle(cornerRadius: 15)) // Rounded corners for the image background
                            .padding()
                        
                        // Display the title of the bee kind.
                        Text(beeKind.rawValue)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                            .foregroundColor(.appYellow)
                            .opacity(0.8)// Text color to match design
                        
                        // Display the description of the bee kind.
                        Text(beeKind.description)
                            .font(.body)
                            .padding(.bottom, 8)
                            .foregroundColor(.white) // Description color for contrast
                            .padding()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Bee Kind Info")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("OK") {
                dismiss()
            })
            .foregroundStyle(.black)
            .bold()
        }
    }
}

// Preview for `BeeKindDetailView` with a sample bee kind.
#Preview {
    BeeKindDetailView(beeKind: BeeKind.bumbleBee)
}
