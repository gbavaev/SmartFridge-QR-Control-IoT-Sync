import SwiftUI
import RealmSwift

struct HomeView: View {

    @Binding var shouldShowScanner: Bool
    @Binding var scanningType: QRScanningType

    @ObservedObject var localManager: LocalManager

    @Binding var searchText: String

    @Binding var navigationPath: NavigationPath

    var body: some View {
        viewContent()
            .onChange(of: searchText) { newValue, _ in handleSearch(newValue) }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !localManager.existingFridgeItems.isEmpty {
                        ToolbarButton(imageName: "questionmark") {
                            scanningType = .gettingInfo
                            shouldShowScanner = true
                        }

                        ToolbarButton(imageName: "minus") {
                            scanningType = .removing
                            shouldShowScanner = true
                        }
                    }

                    ToolbarButton(imageName: "plus") {
                        scanningType = .adding
                        shouldShowScanner = true
                    }
                }
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        Group {
            if localManager.existingFridgeItems.isEmpty {
                if searchText.removeExtraSpaces().isEmpty {
                    ContentUnavailableView(
                        "Ваш холодильник пуст :(",
                        systemImage: "text.badge.xmark",
                        description: Text("Нажмите сюда, чтобы добавить первый продукт")
                    )
                    .onTapGesture {
                        scanningType = .adding
                        shouldShowScanner = true
                    }
                } else {
                    ContentUnavailableView.search(text: searchText)
                }
            } else {
                List {
                    ForEach(localManager.existingFridgeItems) { item in
                        Button {
                            navigationPath.append(item.product)
                        } label: {
                            fridgeItemCell(item: item)
                                .contextMenu {
                                    Button("Убрать из холодильника", systemImage: "arrowshape.turn.up.backward") {
                                        localManager.removeFridgeItem(item.product)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func fridgeItemCell(item: FridgeItemUIModel) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if item.product.expiration.startOfDate <= .now.yesterday.startOfDate {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(16)
                            .foregroundStyle(.red)
                    } else if item.product.expiration.startOfDate >= .now.tomorrow.startOfDate {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(16)
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(16)
                            .foregroundStyle(.yellow)
                    }


                    MarkdownText(text: "\(item.product.name): \(item.count)", markdown: searchText)
                        .font(.headline)
                }

                MarkdownText(text: item.product.type, markdown: searchText, foregroundColor: .gray)
                    .font(.footnote)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(12)
                .foregroundStyle(.gray.opacity(0.6))
        }
    }

    private func handleSearch(_ newValue: String) {
        let search = searchText.removeExtraSpaces()

        localManager.getFridgeItems(filter: search.isEmpty ? nil : search)
    }
}

#Preview {
    HomeView(
        shouldShowScanner: .constant(false),
        scanningType: .constant(.adding),
        localManager: .init(),
        searchText: .constant(""),
        navigationPath: .constant(.init())
    )
}
