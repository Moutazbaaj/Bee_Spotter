//
//  AppDelegate.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 14.08.24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Called when the app finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        NotificationManger.shared.requestNotificationPermission()
        return true
    }
    
    // Handles notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("Received notification while app is in foreground")
        // Show the notification as a banner and play sound even when the app is open
        return [.banner, .badge, .sound]
        
    }
    
    // Handles user's interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("User interacted with the notification")
        
        let userInfo = response.notification.request.content.userInfo
        
        if let beeId = userInfo["beeId"], let notificationType = userInfo["notificationType"] as? String {
            // Post a notification to navigate to the BeeReportDetailsView
            await MainActor.run {
                NotificationCenter.default.post(name: .navigateToBeeReport, object: (beeId, notificationType))
            }
        }
    }
    
}
