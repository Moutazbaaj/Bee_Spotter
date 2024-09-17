//
//  NotificationManger.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 13.08.24.
//

import Foundation
import UserNotifications

class NotificationManger: NSObject, ObservableObject {
    
    static let shared = NotificationManger()
    
    @Published var isAuthorized = false  // Indicates if notification services are authorized
    
    override init() {
        super.init()
        checkAuthorizationStatus()
        UNUserNotificationCenter.current().setBadgeCount(0)

    }
    
    // Requests notification permission from the user
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if let error = error {
                    print("Request authorization failed with error: \(error.localizedDescription)")
                } else {
                    print("Notification permission granted: \(granted)")
                }
            }
        }
    }
    
    // Checks the current notification authorization status
    private func checkAuthorizationStatus() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
                if !self!.isAuthorized {
                    print("Notifications are not authorized")
                }
            }
        }
    }
    
    // Schedules a local notification when a new comment is added to a report
    func scheduleCommentLocalNotification(for comment: FireComment, bee: FireBee) {
        let content = UNMutableNotificationContent()
        content.title = "New Comment on Your Report"
        content.body = "'\(comment.username)' commented: '\(comment.text)' on your '\(bee.title)' report"
        content.sound = .default
        content.badge = 1

        // Pass the bee ID and notification type in the userInfo
        let reportInfo: [String: Any] = ["beeId": bee.id ?? "", "notificationType": "comment"]
        content.userInfo = reportInfo

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification request: \(error.localizedDescription)")
            } else {
                print("Comment notification scheduled successfully")
            }
        }
    }
}
