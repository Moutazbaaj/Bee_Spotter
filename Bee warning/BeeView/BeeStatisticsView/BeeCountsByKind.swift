//
//  BeeCountsByKind.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 13.08.24.
//

import SwiftUI
import Charts

struct BeeCountsByKind: View {
    
    @ObservedObject var beeViewModel: BeeViewModel
    
    @State private var beeKindList = false
    
    private let beeKinds: [BeeKind] = [
        .honeyBee, .bumbleBee, .carpenterBee, .masonBee, .leafcutterBee, .sweatBee, .miningBee, .cuckooBee, .woolCarderBee,
        .alkaliBee, .longHornedBee, .tawnyMiningBee, .cuckooBumblebee, .hawkMothBee, .pollenBee, .diggerBee,
        .europeanHoneyBee, .blueOrchardBee, .other
    ]
    
    private let beeKindsColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .pink, .purple, .brown, .gray, .cyan, .teal, .indigo,
        Color(red: 0.75, green: 1.0, blue: 0.0), // Lime
        Color(red: 0.5, green: 0.5, blue: 0.0), // Olive
        Color(red: 0.5, green: 0.0, blue: 0.0), // Maroon
        Color(red: 0.0, green: 0.0, blue: 0.5), // Navy
        Color(red: 1.0, green: 0.84, blue: 0.0), // Gold
        Color(red: 0.9, green: 0.9, blue: 0.98), // Lavender
        .black
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Text("Active Reports: \(beeViewModel.bees.count)")
                        .font(.callout)
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
                    
                    Text("Bee count by kind")
                        .font(.title)
                        .bold()
                        .shadow(color: .appYellow, radius: 10)
                        .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(BeeKind.allCases, id: \.self) { kind in
                                if let count = beeViewModel.beeCountsByKind[kind] {
                                    VStack {
                                        VStack {
                                            Image(kind.imageName)
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .padding(6)
                                                .background(Color.black.opacity(0.9))
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                                .shadow(radius: 10)
                                                .scaledToFit()
                                            
                                        }
                                        .padding()
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        
                                        Text(kind.rawValue)
                                            .font(.callout)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        Text("\(count)")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.appYellow)
                            .shadow(radius: 10)
                    )

                    Divider()
                    
                    let totalReports = beeViewModel.bees.count
                    if totalReports > 0 {
                        
                        Text("Bee percentage chart")
                            .font(.title)
                            .bold()
                            .shadow(color: .appYellow, radius: 10)
                            .padding()
                        
                        // Pie Chart for bee kind counts with percentages
                        ZStack {
                            // Outer circle with shadow
                            Circle()
                                .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                .foregroundColor(.appYellow) // The color of the circle
                                .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                            
                            Chart {
                                ForEach(beeKinds.indices, id: \.self) { index in
                                    let beeKind = beeKinds[index]
                                    if let count = beeViewModel.beeCountsByKind[beeKind], count > 0 {
                                        let percentage = (Double(count) / Double(totalReports)) * 100
                                        SectorMark(
                                            angle: .value("Percentage", percentage),
                                            innerRadius: .ratio(0.3)
                                        )
                                        .opacity(0.8)
                                        .foregroundStyle(beeKindsColors[index % beeKindsColors.count])
                                        .annotation(position: .overlay) {
                                            Text(String(format: "%.1f%%", percentage))
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
                        
                        // Display bee counts by kind
                        if !beeViewModel.beeCountsByKind.isEmpty {
                            
                            Text("Color Code:")
                                .font(.title)
                                .bold()
                                .shadow(color: .appYellow, radius: 10)
                                .padding()
                            VStack(alignment: .leading) {
                                LazyVGrid(columns: [GridItem(.fixed(100), spacing: 16), GridItem(.fixed(100), spacing: 16), GridItem(.fixed(100), spacing: 16)]) {
                                    ForEach(beeKinds.indices, id: \.self) { index in
                                        HStack {
                                            Rectangle()
                                                .fill(beeKindsColors[index % beeKindsColors.count])
                                                .frame(width: 10, height: 30)
                                                .cornerRadius(4)
                                            HStack {
                                                Spacer()
                                                Text("\(beeKinds[index].rawValue)")
                                                    .font(.callout)
                                                Spacer()
                                            }
                                        }
                                        .frame(width: 100, alignment: .leading)
                                    }
                                }
                                .padding(.top, 8)
                            }
                        } else {
                            Text("No data available")
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("No data available")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .navigationTitle("Bee Counts")
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
