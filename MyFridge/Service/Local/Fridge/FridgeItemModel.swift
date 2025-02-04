import Foundation
import RealmSwift

final class FridgeItemModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var name: String
    @Persisted var type: String

    @Persisted var manufactured: Date
    @Persisted var expiration: Date

    @Persisted var weight: Int
    @Persisted var volume: Double

    @Persisted var calories: Int
    @Persisted var fats: Int
    @Persisted var proteins: Int
    @Persisted var carbohydrates: Int

    @Persisted var dateAddedToFridge: Date
    @Persisted var dateRemovedFromFridge: Date?

    @Persisted var notificationID: String

    @Persisted var containGluten: Bool
    @Persisted var containLactose: Bool
}

struct FridgeItemUIModel: Identifiable {
    let id = UUID()

    let product: FridgeItemModel
    var count: Int
}
