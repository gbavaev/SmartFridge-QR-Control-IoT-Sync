import SwiftUI
import RealmSwift

struct ShoppingListView: View {

    @ObservedObject var shoppingListLocalManager: ShoppingLocalManager

    @State private var isAddingNewItem: Bool = false
    @State private var newItemName: String = ""

    var body: some View {
        viewContent()
            .alert("Введите название нового продукта", isPresented: $isAddingNewItem) {
                TextField("Название", text: $newItemName)
                    .textInputAutocapitalization(.never)

                Button("OK") {
                    let name = newItemName.removeExtraSpaces()

                    guard !name.isEmpty else {
                        HapticManager.feedback(style: .heavy)
                        return
                    }

                    shoppingListLocalManager.addShoppingItem(name: name)
                    newItemName = ""
                    isAddingNewItem = false
                }

                Button("Cancel", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarButton(imageName: "plus") {
                        isAddingNewItem = true
                    }
                }
            }
    }

    @ViewBuilder
    private func viewContent() -> some View {
        Group {
            if shoppingListLocalManager.shoppingListItems.isEmpty {
                ContentUnavailableView(
                    "Cписок покупок пуст",
                    systemImage: "text.badge.xmark",
                    description: Text("Нажмите сюда, чтобы добавить первый продукт")
                )
                .onTapGesture {
                    isAddingNewItem = true
                }
            } else {
                List {
                    ForEach(shoppingListLocalManager.shoppingListItems) { item in
                        shoppingItemCell(
                            item: item,
                            onIncrement: { shoppingListLocalManager.incrementCount(for: item) },
                            onDecrement: { shoppingListLocalManager.decrementCount(for: item) },
                            onRemove: { shoppingListLocalManager.removeShoppingItem(item) }
                        )
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func shoppingItemCell(
        item: ShoppingListItemUIModel,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void,
        onRemove: @escaping () -> Void
    ) -> some View {
        HStack {
            Text("\(item.name): \(item.count)")
                .font(.headline)

            Spacer()

            HStack(spacing: 10) {
                shoppingItemCountContol(
                    "plus",
                    color: .green,
                    action: onIncrement
                )

                shoppingItemCountContol(
                    "minus",
                    color: .orange,
                    isDisabled: (item.count < 2),
                    action: onDecrement
                )

                shoppingItemCountContol(
                    "trash",
                    color: .red,
                    action: onRemove
                )
            }
        }
    }

    @ViewBuilder
    private func shoppingItemCountContol(
        _ imageName: String,
        color: Color,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .frame(20)
            .padding(10)
            .background(color.opacity(0.4))
            .cornerRadius(16)
            .clipShape(.rect(cornerRadius: 16))
            .contentShape(.rect(cornerRadius: 16))
            .opacity(isDisabled ? 0.5 : 1)
            .onTapGesture {
                if !isDisabled {
                    action()
                }
            }
    }
}

#Preview {
    ShoppingListView(
        shoppingListLocalManager: .init()
    )
}
