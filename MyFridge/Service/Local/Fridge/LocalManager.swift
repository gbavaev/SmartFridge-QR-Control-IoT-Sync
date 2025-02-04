import Foundation
import RealmSwift

final class LocalManager: ObservableObject {

    @Published var existingFridgeItems: [FridgeItemUIModel] = []

    private let realm: Realm
    private let calendar: Calendar

    init() {
        realm = try! Realm()
        calendar = .current

        logger.info("DEBUG: Successfully initialized Realm in LocalManager")

        getFridgeItems()
    }

    func addFridgeItem(
        name: String,
        type: String,
        manufacturingDate: Date,
        expirationDate: Date,
        weight: Int,
        volume: Double,
        calories: Int,
        fats: Int,
        proteins: Int,
        carbohydrates: Int,
        containGluten: Bool,
        containLactose: Bool,
        dateAddedToFridge: Date = .now
    ) {
        let notificationID = NotificationManager.shared.sendNotification(
            itemName: name,
            date: expirationDate
        )

        let item = FridgeItemModelCreator.create(
            name: name,
            type: type,
            manufacturingDate: manufacturingDate,
            expirationDate: expirationDate,
            weight: weight,
            volume: volume,
            calories: calories,
            fats: fats,
            proteins: proteins,
            carbohydrates: carbohydrates,
            containGluten: containGluten,
            containLactose: containLactose,
            notificationID: notificationID,
            dateAddedToFridge: dateAddedToFridge
        )

        realm.perform {
            realm.add(item)
        }

        getFridgeItems()
    }

    func removeFridgeItem(
        name: String,
        type: String,
        manufacturingDate: Date,
        expirationDate: Date,
        weight: Int,
        volume: Double,
        calories: Int,
        fats: Int,
        proteins: Int,
        carbohydrates: Int,
        containGluten: Bool,
        containLactose: Bool,
        onError: () -> Void
    ) {
        let item = FridgeItemModelCreator.create(
            name: name,
            type: type,
            manufacturingDate: manufacturingDate,
            expirationDate: expirationDate,
            weight: weight,
            volume: volume,
            calories: calories,
            fats: fats,
            proteins: proteins,
            carbohydrates: carbohydrates,
            containGluten: containGluten,
            containLactose: containLactose,
            notificationID: ""
        )

        if let object = getItemIfExists(item) {
            removeFridgeItem(object)
        } else {
            onError()
        }
    }

    func getFridgeItems(filter: String? = nil) {
        var objects = Array(realm.objects(FridgeItemModel.self).filter({ $0.dateRemovedFromFridge == nil }).reversed())

        if let filter {
            let filtering = filter.lowercased()

            objects = objects.filter({
                $0.name.lowercased().contains(filtering) || $0.type.lowercased().contains(filtering)
            })
        }

        var existingItems: [FridgeItemUIModel] = []

        for object in objects {
            if let index = existingItems.firstIndex(where: { $0.product.isExistingEqualAsUIModel(to: object) }) {
                existingItems[index].count += 1
            } else {
                existingItems.append(.init(product: object, count: 1))
            }
        }

        existingItems = existingItems.sorted { lhs, rhs in
            lhs.product.name < rhs.product.name
        }

        self.existingFridgeItems = existingItems
    }

    func getItemIfExists(
        name: String,
        type: String,
        manufacturingDate: Date,
        expirationDate: Date,
        weight: Int,
        volume: Double,
        calories: Int,
        fats: Int,
        proteins: Int,
        carbohydrates: Int,
        containGluten: Bool,
        containLactose: Bool
    ) -> FridgeItemModel? {
        let item = FridgeItemModelCreator.create(
            name: name,
            type: type,
            manufacturingDate: manufacturingDate,
            expirationDate: expirationDate,
            weight: weight,
            volume: volume,
            calories: calories,
            fats: fats,
            proteins: proteins,
            carbohydrates: carbohydrates,
            containGluten: containGluten,
            containLactose: containLactose,
            notificationID: ""
        )

        return getItemIfExists(item)
    }

    func removeFridgeItem(_ item: FridgeItemModel) {
        NotificationManager.shared.removeNotification(with: item.notificationID)

        realm.perform {
            item.dateRemovedFromFridge = .now.startOfDate
        }

        getFridgeItems()
    }

    private func getItemIfExists(_ item: FridgeItemModel) -> FridgeItemModel? {
        realm.objects(FridgeItemModel.self).filter({ $0.isEqual(to: item) }).first
    }
}
