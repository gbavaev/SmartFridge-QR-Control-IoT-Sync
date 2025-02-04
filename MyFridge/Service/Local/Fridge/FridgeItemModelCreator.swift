import Foundation

final class FridgeItemModelCreator {
    static func create(
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
        notificationID: String,
        dateAddedToFridge: Date = .now
    ) -> FridgeItemModel {
        let item = FridgeItemModel()
        item.name = name
        item.type = type

        item.manufactured = manufacturingDate
        item.expiration = expirationDate

        item.weight = weight
        item.volume = volume

        item.calories = calories
        item.fats = fats
        item.proteins = proteins
        item.carbohydrates = carbohydrates

        item.dateRemovedFromFridge = nil
        item.notificationID = notificationID

        item.containGluten = containGluten
        item.containLactose = containLactose

        item.dateAddedToFridge = dateAddedToFridge

        return item
    }
}
