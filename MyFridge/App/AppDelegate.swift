import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        logger.info(
            """
            Successfully opened the app.
            App version \(Bundle.main.appVersion).
            App build \(Bundle.main.appBuild).
            """
        )

        return true
    }
}
