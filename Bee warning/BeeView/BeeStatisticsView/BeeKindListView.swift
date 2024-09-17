//
//  BeeKindListView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 05.08.24.
//

import SwiftUI

struct BeeKindListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBeeKind: BeeKind? // State variable to manage the selected bee kind
    
    var body: some View {
        NavigationStack {
            List(BeeKind.allCases) { bee in
                VStack {
                    Image(bee.imageName)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 15)
                        .padding(4)
                        .background(Color.appYellow.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Button(action: {
                        selectedBeeKind = bee // Set the selected bee kind
                    }) {
                        HStack {
                            Spacer()
                            Text(bee.rawValue)
                                .padding()
                                .background(Color.appYellow)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .bold()
                                .shadow(radius: 10)
                                .padding()
                            Spacer()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners for the text background
                }
                .clipShape(RoundedRectangle(cornerRadius: 15)) // Rounded corners for the cell
            }
            .listStyle(.plain)
            .navigationTitle("Bee Kinds")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .foregroundStyle(.appYellow)
            .sheet(item: $selectedBeeKind) { beeKind in
                BeeKindDetailView(beeKind: beeKind)
                    .presentationDetents([.medium, .large])
            }
        }
        .foregroundStyle(.appYellow)
    }
}

#Preview {
    BeeKindListView()
}
