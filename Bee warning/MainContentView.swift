//
//  MainContentView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var notificationManger: NotificationManger
    @StateObject private var beeViewModel = BeeViewModel.shared  // Shared instance of BeeViewModel
    
    @State private var isSplashScreenShown = true
    @State private var selectedBee: FireBee?
    @State private var showComments = false
    
    var body: some View {
        Group {
            if isSplashScreenShown {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isSplashScreenShown = false
                        }
                    }
            } else {
                if authViewModel.isUserLoggedIn {
                    if locationManager.isAuthorized {
                        MainTabView()
                            .onReceive(NotificationCenter.default.publisher(for: .navigateToBeeReport)) { notification in
                                if let (beeId, notificationType) = notification.object as? (String, String) {
                                    if let bee = beeViewModel.getBee(byId: beeId) {
                                        selectedBee = bee
                                        showComments = notificationType == "comment"
                                    }
                                }
                            }
                            .sheet(item: $selectedBee) { bee in
                                if showComments {
                                    AllCommentsView(beeViewModel: beeViewModel, bee: bee)
                                        .presentationDetents([.medium])
                                } else {
                                    BeeReportDetailsView(beeViewModel: beeViewModel, bee: bee)
                                        .presentationDetents([.medium])
                                }
                            }
                    } else {
                        LocationDeniedView()
                    }
                } else {
                    LoginView()
                }
            }
        }
    }
}

extension Notification.Name {
    static let navigateToBeeReport = Notification.Name("navigateToBeeReport")
}
