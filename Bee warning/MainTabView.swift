//
//  MainTabView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            BeeMapView()
                .tabItem {
                    Label("FireBee Map", systemImage: "map")
                }

            StatisticsView()
                .tabItem {
                    Label("Informations", systemImage: "info.square")
                }
            MyBeesListView()
                .tabItem {
                    Label("My Reports", systemImage: "list.bullet")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }

        }
        .accentColor(.appYellow)
    }
}
