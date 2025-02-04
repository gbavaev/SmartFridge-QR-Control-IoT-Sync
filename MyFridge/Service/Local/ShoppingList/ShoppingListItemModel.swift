import Foundation
import RealmSwift

final class ShoppingListItemModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var name: String
    @Persisted var count: Int
}

extension ShoppingListItemModel: Identifiable {
    func isEqual(to object: ShoppingListItemModel) -> Bool {
        (self.name == object.name) &&
        (self.count == object.count)
    }

    func isEqual(to object: ShoppingListItemUIModel) -> Bool {
        (self.name == object.name) &&
        (self.count == object.count)
    }
}

// я блять реалм в рот ебал сука. блять Object was invalidated or deleted
struct ShoppingListItemUIModel: Identifiable, Hashable {
    let id = UUID()

    var name: String
    var count: Int
}
// даже пробовать не стал без этого воркэраунда ибо знаю что будет хуйня
