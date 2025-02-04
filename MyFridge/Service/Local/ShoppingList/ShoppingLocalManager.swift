import Foundation
import RealmSwift

final class ShoppingLocalManager: ObservableObject {

    @Published var shoppingListItems: [ShoppingListItemUIModel] = []

    private let realm: Realm

    init() {
        realm = try! Realm()

        logger.info("DEBUG: Successfully initialized Realm in ShoppingLocalManager")

        getShoppingItems()
    }

    func addShoppingItem(name: String) {
        let item = createShoppingListItemModel(name: name)

        realm.perform {
            realm.add(item)
        }

        getShoppingItems()
    }

    func incrementCount(for item: ShoppingListItemUIModel) {
        if let object = getShoppingItemModel(item) {
            incrementCount(for: object)
        }
    }

    func decrementCount(for item: ShoppingListItemUIModel) {
        if let object = getShoppingItemModel(item) {
            decrementCount(for: object)
        }
    }

    func removeShoppingItem(_ item: ShoppingListItemUIModel) {
        if let object = getShoppingItemModel(item) {
            removeShoppingItem(object)
        }
    }

    func removeShoppingItem(name: String) {
        if let object = getShoppingItemModel(name) {
            removeShoppingItem(object)
        }
    }

    func getShoppingItems(filter: String? = nil) {
        var objects = Array(realm.objects(ShoppingListItemModel.self).reversed())

        if let filter {
            let filtering = filter.lowercased()

            objects = objects.filter({
                $0.name.lowercased().contains(filtering)
            })
        }

        self.shoppingListItems = Array(objects.map {
            ShoppingListItemUIModel(name: $0.name, count: $0.count) }
        )
    }

    func isProductAlreadyAdded(_ name: String) -> Bool {
        !realm.objects(ShoppingListItemModel.self).filter({ $0.name == name }).isEmpty
    }

    private func incrementCount(for item: ShoppingListItemModel) {
        realm.perform {
            item.count += 1
        }

        getShoppingItems()
    }

    private func decrementCount(for item: ShoppingListItemModel) {
        guard item.count > 1 else { return }

        realm.perform {
            item.count -= 1
        }

        getShoppingItems()
    }

    private func removeShoppingItem(_ item: ShoppingListItemModel) {
        realm.perform {
            realm.delete(item)
        }

        getShoppingItems()
    }

    private func createShoppingListItemModel(
        name: String
    ) -> ShoppingListItemModel {
        let item = ShoppingListItemModel()
        item.name = name
        item.count = 1

        return item
    }

    private func getShoppingItemModel(_ item: ShoppingListItemUIModel) -> ShoppingListItemModel? {
        realm.objects(ShoppingListItemModel.self).filter({ $0.isEqual(to: item) }).first
    }

    private func getShoppingItemModel(_ name: String) -> ShoppingListItemModel? {
        realm.objects(ShoppingListItemModel.self).filter({ $0.name == name }).first
    }
}
