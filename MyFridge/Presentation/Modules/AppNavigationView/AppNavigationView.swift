import SwiftUI
import CodeScanner

struct AppNavigationView: View {

    @StateObject private var localManager = LocalManager()
    @StateObject private var shoppingLocalManager = ShoppingLocalManager()
    @StateObject private var statisticsVM = StatisticsViewModel()

    @State private var shouldShowScanner: Bool = false

    @State private var shouldShowError: Bool = false
    @State private var errorText: String = ""

    @State private var scanningType: QRScanningType = .adding
    @State private var searchText: String = ""

    @State private var navigationPath = NavigationPath()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            homeViewContent()
                .tag(0)
                .tabItem {
                    Label("Продукты", systemImage: "house")
                }

            statisticsViewContent()
                .tag(1)
                .tabItem {
                    Label("Статистика", systemImage: "list.clipboard")
                }

            shoppingListContent()
                .tag(2)
                .tabItem {
                    Label("Список покупок", systemImage: "cart")
                }
        }
        .sheet(isPresented: $shouldShowScanner, content: scannerView)
        .alert(errorText, isPresented: $shouldShowError) {
            Button("Хорошо", role: .cancel) { }
        }
    }

    @ViewBuilder
    private func homeViewContent() -> some View {
        // path нужен потому что экран информации может открываться не только с кнопки,
        // но и из сканера (открытие информации - кнопка "?")
        NavigationStack(path: $navigationPath) {
            HomeView(
                shouldShowScanner: $shouldShowScanner,
                scanningType: $scanningType,
                localManager: localManager,
                searchText: $searchText,
                navigationPath: $navigationPath
            )
            .navigationTitle("Холодильник")
            .background(.background.secondary)
            .if(!localManager.existingFridgeItems.isEmpty || !searchText.removeExtraSpaces().isEmpty) {
                $0.searchable(text: $searchText, prompt: "Название или тип продукта")
            }
            .navigationDestination(for: FridgeItemModel.self) { item in
                FridgeItemDetailView(
                    item: item,
                    shoppingListLocalManager: shoppingLocalManager
                )
            }
        }
    }

    @ViewBuilder
    private func statisticsViewContent() -> some View {
        NavigationStack {
            StatisticsView(
                statisticsVM: statisticsVM,
                shoppingListLocalManager: shoppingLocalManager
            )
            .navigationTitle("Статистика")
            .background(.background.secondary)
        }
    }

    @ViewBuilder
    private func shoppingListContent() -> some View {
        NavigationStack {
            ShoppingListView(shoppingListLocalManager: shoppingLocalManager)
                .navigationTitle("Список покупок")
                .background(.background.secondary)
        }
    }

    @ViewBuilder
    private func scannerView() -> some View {
        CodeScannerView(
            codeTypes: [.dataMatrix, .qr, .microQR],
            showViewfinder: true,
            simulatedData: SimulatorQRStringProvider.provide()
        ) {
            QRScanningHandler.handle(
                $0.publisher.result,
                scanningType: scanningType,
                localManager: localManager,
                onProductDoesntExist: { showError("Этого продукта нет в Вашем холодильнике") },
                pathAdding: { navigationPath.append($0) },
                onParsingError: { showError($0.localizedDescription) }
            )

            shouldShowScanner = false
        }
        .overlay(alignment: .topTrailing, content: scannerDismissButton)
        .ignoresSafeArea(edges: .bottom)
        .interactiveDismissDisabled()
    }

    @ViewBuilder
    private func scannerDismissButton() -> some View {
        Button {
            shouldShowScanner = false
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(16)
                .padding(16)
                .background(Color.gray)
                .clipShape(Circle())
        }
        .padding(24)
    }

    private func showError(_ error: String) {
        errorText = error
        shouldShowError = true
    }
}

#Preview {
    AppNavigationView()
}
