import UIKit

final class HapticManager {
    static func feedback(
        style: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        intensity: Double = 1
    ) {
        UIImpactFeedbackGenerator(style: style)
            .impactOccurred(intensity: intensity)
    }

    static func onChanged() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
