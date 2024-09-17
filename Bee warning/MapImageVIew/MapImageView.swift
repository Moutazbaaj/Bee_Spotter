//
//  MapImageView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI
import MapKit
import FirebaseFirestore

// A view that displays a location image of a bee sighting using Google Street View.
struct MapImageView: View {

    @StateObject private var imageViewModel = MapImageViewModel.shared

    // The latitude of the location.
    let latitude: Double
    let longitude: Double

    var body: some View {
        VStack {
            if imageViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = imageViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let locationImage = imageViewModel.locationImage {
                Image(uiImage: locationImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(4)
                    .background(Color.appYellow.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 15)
                    .padding()
            } else {
                Text("No image available")
            }
        }
        .onAppear {
            imageViewModel.fetchLocationImage(latitude: latitude, longitude: longitude)
        }
    }
}

struct LocationImageView_Previews: PreviewProvider {
    static var previews: some View {
        MapImageView(latitude: 37.332331, longitude: -122.031219)
    }
}
