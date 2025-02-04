import SwiftUI

struct StatisticsView: View {

    @ObservedObject var statisticsVM: StatisticsViewModel
    @ObservedObject var shoppingListLocalManager: ShoppingLocalManager

    private var collection: [FridgeItemUIModel] {
        statisticsVM.showRemovedProductsStatistics ? statisticsVM.removedFridgeItems : statisticsVM.addedFridgeItems
    }

    var body: some View {
        List {
            periodPicker()

            ForEach(collection) { item in
                productCell(item: item)
            }
        }
        .onAppear {
            if !statisticsVM.hasAppeared {
                fetchStatistics()
                statisticsVM.hasAppeared = true
            }
        }
        .onChange(of: statisticsVM.selectedPeriod) { _, _ in fetchStatistics() }
        .onChange(of: statisticsVM.endOfPeriod) { _, _ in fetchStatistics() }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                DatePicker(selection: $statisticsVM.endOfPeriod, in: ...Date(), displayedComponents: .date) {}
                    .buttonStyle(.borderedProminent)

                statisticsTypeButton()
            }
        }
        .overlay {
            if collection.isEmpty {
                ContentUnavailableView(
                    "В выбранном периоде нет продуктов",
                    systemImage: "text.badge.xmark"
                )
            }
        }
    }

    @ViewBuilder
    private func periodPicker() -> some View {
        Picker("", selection: $statisticsVM.selectedPeriod) {
            ForEach(StatisticsPeriodType.allCases) {
                Text($0.title)
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }

    @ViewBuilder
    private func productCell(item: FridgeItemUIModel) -> some View {
        let dateText: String = {
            if statisticsVM.showRemovedProductsStatistics, let date = item.product.dateRemovedFromFridge {
                return date.asDay()
            }

            return item.product.dateAddedToFridge.asDay()
        }()

        NavigationLink {
            FridgeItemDetailView(
                item: item.product,
                shoppingListLocalManager: shoppingListLocalManager
            )
        } label: {
            HStack {
                Text("\(item.product.name): \(item.count)")
                    .font(.headline)

                Spacer()

                Text(dateText)
                    .font(.caption)
            }
        }
    }

    @ViewBuilder
    private func statisticsTypeButton() -> some View {
        Image(systemName: statisticsVM.showRemovedProductsStatistics ? "minus" : "plus")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .bold()
            .frame(16)
            .padding(8)
            .background(statisticsVM.showRemovedProductsStatistics ? .red.opacity(0.3) : .green.opacity(0.3))
            .clipShape(Circle())
            .onTapGesture {
                statisticsVM.showRemovedProductsStatistics.toggle()
            }
    }

    private func fetchStatistics() {
        statisticsVM.getRemovedFridgeItems(filter: statisticsVM.selectedPeriod, endOfPeriod: statisticsVM.endOfPeriod)
        statisticsVM.getAddedFridgeItems(filter: statisticsVM.selectedPeriod, endOfPeriod: statisticsVM.endOfPeriod)
    }
}

#Preview {
    StatisticsView(
        statisticsVM: .init(),
        shoppingListLocalManager: .init()
    )
}
