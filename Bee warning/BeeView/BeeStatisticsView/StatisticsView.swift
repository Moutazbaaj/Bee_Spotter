//
//  StatisticsView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 05.08.24.
//

import SwiftUI

struct StatisticsView: View {
    
//    // The bee report to display.
//    var bee: FireBee

    // View model to manage the bee reports.
    @StateObject private var beeViewModel = BeeViewModel.shared

    // State to manage the selected tab (0 for In My Area, 1 for Worldwide).
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                // Segmented control for switching between details.
                Picker("Details", selection: $selectedTab) {
                    Text("In My Area").tag(0)
                    Text("Worldwide").tag(1)
                }
                .pickerStyle(.segmented)  // Uses segmented control style.
                .padding()  // Adds padding around the picker.

                // Display content based on the selected tab.
                if selectedTab == 0 {
                    BeeStatisticsInfoView(beeViewModel: beeViewModel)
                } else {
                    BeeCountsByKind(beeViewModel: beeViewModel)
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
}
