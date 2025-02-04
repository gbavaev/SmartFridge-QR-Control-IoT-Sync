import SwiftUI

struct FridgeItemDetailView: View {

    @State private var isItemAddedToShoppingList: Bool = false

    let item: FridgeItemModel

    @ObservedObject var shoppingListLocalManager: ShoppingLocalManager

    private var navigationTitle: String {
        if item.dateRemovedFromFridge != nil {
            return item.name
        }

        return "\(item.name) – \(getExpirationDateStatus())"
    }

    var body: some View {
        Form {
            Section {
                Text("Категория: \(item.type)")
            }

            Section("Даты") {
                Text("Изготовлено: \(item.manufactured.asDay())")
                Text("Срок годности: \(item.expiration.asDay())")

                Text("Добавлено: \(item.dateAddedToFridge.asDay())")

                if let dateRemovedFromFridge = item.dateRemovedFromFridge {
                    Text("Удалено: \(dateRemovedFromFridge.asDay())")
                }
            }

            Section("Физические величины") {
                Text("Вес: \(item.weight)гр")
                Text("Объем: \(String(format: "%.2f", item.volume))м³")
            }

            Section("Пищевые свойства") {
                Text("Калории: \(item.calories)ккал/100гр")
                Text("Жиры: \(item.fats)гр/100гр")
                Text("Белки: \(item.proteins)гр/100гр")
                Text("Углеводы: \(item.carbohydrates)гр/100гр")
            }

            if item.containGluten || item.containLactose {
                Section("Популярные аллергены") {
                    if item.containGluten {
                        Text("Глютен")
                    }

                    if item.containLactose {
                        Text("Лактоза")
                    }
                }
            }
        }
        .navigationTitle(self.navigationTitle)
        .onAppear {
            isItemAddedToShoppingList = shoppingListLocalManager.isProductAlreadyAdded(item.name)
        }
        .toolbar(content: shoppingListButton)
    }

    @ViewBuilder
    private func shoppingListButton() -> some View {
        Button(action: handleShoppingListAction) {
            HStack {
                Image(systemName: isItemAddedToShoppingList ? "cart.fill" : "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(24)

                Image(systemName: isItemAddedToShoppingList ? "checkmark.circle" : "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(32)
            }
        }
        .foregroundColor(isItemAddedToShoppingList ? .green : .orange)
        .padding()
    }

    private func getExpirationDateStatus() -> String {
        if item.expiration.startOfDate <= .now.yesterday.startOfDate {
            return "❌"
        } else if item.expiration.startOfDate >= .now.tomorrow.startOfDate {
            return "✅"
        }

        return "⚠️"
    }

    private func handleShoppingListAction() {
        if isItemAddedToShoppingList {
            shoppingListLocalManager.removeShoppingItem(name: item.name)
            isItemAddedToShoppingList = false
        } else {
            shoppingListLocalManager.addShoppingItem(name: item.name)
            isItemAddedToShoppingList = true
        }
    }
}
