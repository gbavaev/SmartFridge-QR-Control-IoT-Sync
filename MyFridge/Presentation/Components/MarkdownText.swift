import SwiftUI

struct MarkdownText: View {

    var text: String
    var markdown: String
    var foregroundColor: Color
    var accentColor: Color

    init(
        text: String,
        markdown: String,
        foregroundColor: Color = .primary,
        accentColor: Color = .accentColor
    ) {
        self.text = text
        self.markdown = markdown
        self.foregroundColor = foregroundColor
        self.accentColor = accentColor
    }

    var body: some View {
        Text(text) { str in
            if let range = str.range(
                of: markdown.removeExtraSpaces(),
                options: .caseInsensitive
            ) {
                str[range].foregroundColor = accentColor
            }
        }
        .foregroundStyle(foregroundColor)
    }
}
