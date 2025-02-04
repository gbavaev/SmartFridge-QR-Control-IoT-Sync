import Foundation
import UserNotificationsUI

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Static Properties

    static let shared = NotificationManager()

    // MARK: - Internal Properties

    var isNotificationEnabled: Bool = false

    // MARK: - Private Properties

    private let calendar = Calendar.current

    // MARK: - Init

    private override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self

        requestAuthorization()

        checkNotificationStatus()
    }

    // MARK: - Internal Functions

    func sendNotification(
        itemName: String,
        date: Date
    ) -> String {
        let title = itemName + " скоро испортится"

        let warningDate = calendar.date(byAdding: .hour, value: -1, to: date) ?? date

        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: warningDate)

        let notificationID = sendNotification(title: title, dateComponents: dateComponents)

        logger.info("Successfully sent notification with ID: \(notificationID).")

        return notificationID
    }

    func removeNotification(with id: String) {
        logger.info("Successfully removed notification with ID: \(id).")

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Private Functions

    @discardableResult
    private func sendNotification(title: String, dateComponents: DateComponents) -> String {
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default

        let id = UUID().uuidString

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                logger.error("\(error.localizedDescription)")
            }
        }

        return id
    }
}

// MARK: - Is Notification Enabled
extension NotificationManager {
    func requestAuthorization(callback: @escaping () -> Void = {}) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
                if let error {
                    logger.error("\(error.localizedDescription)")
                }
            }

        self.checkNotificationStatus()
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { status in
                switch status.authorizationStatus {
                case .denied, .ephemeral:
                    self.isNotificationEnabled = false
                case .authorized, .notDetermined, .provisional:
                    self.isNotificationEnabled = true
                @unknown default:
                    print("DEBUG: unowned notification status")
                }
            }
    }
}

// MARK: - UNUserNotificationCenterDelegate conformance
extension NotificationManager {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .list, .banner])
    }
}
