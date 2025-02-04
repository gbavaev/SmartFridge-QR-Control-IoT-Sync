import Foundation
import UIKit

extension String {
    func removeExtraSpaces() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    func openURL() {
        if let url = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
