import SwiftUI

struct ToolbarButton: View {

    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .bold()
                .frame(16)
                .clipShape(Circle())
        }
        .buttonStyle(.borderedProminent)
        .accentColor(.secondary.opacity(0.7))
    }
}
