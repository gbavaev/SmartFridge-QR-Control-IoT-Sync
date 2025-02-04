import UIKit

func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

func delay(
    _ time: Double,
    action: @escaping () -> Void
) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: action)
}
