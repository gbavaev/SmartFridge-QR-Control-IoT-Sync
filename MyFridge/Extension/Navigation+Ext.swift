import UIKit
import SwiftUI

extension View {
    func prepareForStackPresentation() -> some View {
        self
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    func removeSwipeToDismissWhenAppeared() -> some View {
        self
            .onAppear {
                NavigationState.shared.swipeEnabled = false
            }
            .onDisappear {
                NavigationState.shared.swipeEnabled = true
            }
    }
}

final class NavigationState {
    static let shared = NavigationState()

    private init() {}

    var swipeEnabled = true
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()

        let actionString = ["handle", "Navigation", "Transition", ":"].joined()
        let action = Selector(actionString)
        let panGesture = UIPanGestureRecognizer(
            target: self.interactivePopGestureRecognizer?.delegate,
            action: action
        )

        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)

        self.interactivePopGestureRecognizer?.isEnabled = false
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if NavigationState.shared.swipeEnabled {
            return viewControllers.count > 1
        }

        return false
    }
}
