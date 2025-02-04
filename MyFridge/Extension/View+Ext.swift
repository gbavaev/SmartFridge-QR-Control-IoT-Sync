import SwiftUI

// MARK: - Layout

extension View {

    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    func hTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    func vTop() -> some View {
        frame(maxHeight: .infinity, alignment: .top)
    }

    func vCenter() -> some View {
        frame(maxHeight: .infinity, alignment: .center)
    }

    func vBottom() -> some View {
        frame(maxHeight: .infinity, alignment: .bottom)
    }

    func frame(_ value: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: value, height: value, alignment: alignment)
    }

    func height(_ height: CGFloat, alignment: Alignment = .center) -> some View {
        frame(height: height, alignment: alignment)
    }

    func width(_ width: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: width, alignment: alignment)
    }
}

// MARK: - Helpful Properties

extension View {
    var isSmallDevice: Bool { UIScreen.main.bounds.height < 700 }
}

// MARK: - Keyboard

extension View {
    func onTapEndEditing() -> some View {
        onTapGesture {
            hideKeyboard()
        }
    }

    func onTapContinueEditing() -> some View {
        onTapGesture { }
    }
}

// MARK: - Conditional Modifier
extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
