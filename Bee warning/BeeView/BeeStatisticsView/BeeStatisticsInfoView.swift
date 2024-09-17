//
//  BeeStatisticsInfoView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 03.07.24.
//

import SwiftUI
import Charts

struct BeeStatisticsInfoView: View {
    
    @ObservedObject var beeViewModel: BeeViewModel
    
    private let distanceLabels = ["5m", "10m", "50m", "100m", "500m", "1km", "5km", "10km", "50km"]
    private let distanceColors: [Color] = [.red, .orange, .yellow, .green, .blue, .pink, .purple, .brown, .gray]
    
    @State private var beeKindList = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Text("Bees reports statistics: ")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.appYellow)
                                .shadow(radius: 10)
                        )
                        .padding()
                    
                    Divider()
                    
                    if !beeViewModel.nearbyBeesCounts.isEmpty {
                        let totalReports = beeViewModel.nearbyBeesCounts.reduce(0, +)
                        
                        Text("Bee count bye distance")
                            .font(.title)
                            .bold()
                            .shadow(color: .appYellow, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            .padding()
                        
                        // First Chart - Bar Chart for percentage
                        Chart {
                            ForEach(distanceLabels.indices, id: \.self) { index in
                                BarMark(
                                    x: .value("Distance", distanceLabels[index]),
                                    y: .value("Count", beeViewModel.nearbyBeesCounts.indices.contains(index) ? beeViewModel.nearbyBeesCounts[index] : 0)
                                )
                                .foregroundStyle(distanceColors[index % distanceColors.count])
                            }
                        }
                        .frame(height: 200)
                        
                        if totalReports > 0 {
                            
                            Text("Bee percentage chart")
                                .font(.title)
                                .bold()
                                .shadow(color: .appYellow, radius: 10)
                                .padding()
                            
                            // Second Chart - Pie Chart for counts
                            ZStack {
                                // Outer circle with shadow
                                Circle()
                                    .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                    .foregroundColor(.appYellow) // The color of the circle
                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                // Your chart inside the circle
                                Chart {
                                    ForEach(beeViewModel.nearbyBeesCounts.indices, id: \.self) { index in
                                        if beeViewModel.nearbyBeesCounts[index] > 0 {
                                            SectorMark(
                                                angle: .value("Count", beeViewModel.nearbyBeesCounts[index]),
                                                innerRadius: .ratio(0.3)
                                            )
                                            .opacity(0.8)
                                            .foregroundStyle(distanceColors[index % distanceColors.count])
                                            .annotation(position: .overlay) {
                                                Text(beeViewModel.percentage(of: beeViewModel.nearbyBeesCounts[index], in: totalReports))
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 350)
                                .padding()
                            }
                            .frame(width: 351, height: 351) // Adjust the frame size to control circle size
                            .padding()
                            
                            Divider()
                            
                        } else {
                            Text("No data available")
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("No data available")
                            .foregroundColor(.red)
                        
                        Divider()
                    }
            
                }
                .padding()
                .navigationTitle("Statistics")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    beeKindList = true
                }) {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
                )
                .sheet(isPresented: $beeKindList) {
                    BeeKindListView()
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

#Preview {
    BeeStatisticsInfoView(beeViewModel: BeeViewModel())
}
