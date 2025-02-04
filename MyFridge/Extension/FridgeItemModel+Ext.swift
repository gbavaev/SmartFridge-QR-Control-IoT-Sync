import Foundation

extension FridgeItemModel: Identifiable {
    func isEqual(to object: FridgeItemModel) -> Bool {
        (self.name == object.name) &&
        (self.type == object.type) &&
        (self.manufactured == object.manufactured) &&
        (self.expiration == object.expiration) &&
        (self.weight == object.weight) &&
        (self.volume == object.volume) &&
        (self.calories == object.calories) &&
        (self.fats == object.fats) &&
        (self.proteins == object.proteins) &&
        (self.carbohydrates == object.carbohydrates) &&
        (self.dateRemovedFromFridge == object.dateRemovedFromFridge) &&
        (self.containGluten == object.containGluten) &&
        (self.containLactose == object.containLactose)
    }

    func isRemovedEqualAsUIModel(to object: FridgeItemModel) -> Bool {
        guard
            (self.name == object.name) &&
            (self.type == object.type) &&
            (self.manufactured == object.manufactured) &&
            (self.expiration == object.expiration) &&
            (self.weight == object.weight) &&
            (self.volume == object.volume) &&
            (self.calories == object.calories) &&
            (self.fats == object.fats) &&
            (self.proteins == object.proteins) &&
            (self.carbohydrates == object.carbohydrates) &&
            (self.containGluten == object.containGluten) &&
            (self.containLactose == object.containLactose)
        else { return false }

        guard
            let dateRemovedFromFridge1 = self.dateRemovedFromFridge,
            let dateRemovedFromFridge2 = object.dateRemovedFromFridge
        else { return false }

        return Calendar.current.isDate(dateRemovedFromFridge1, inSameDayAs: dateRemovedFromFridge2)
    }

    func isExistingEqualAsUIModel(to object: FridgeItemModel) -> Bool {
        guard
            (self.name == object.name) &&
            (self.type == object.type) &&
            (self.manufactured == object.manufactured) &&
            (self.expiration == object.expiration) &&
            (self.weight == object.weight) &&
            (self.volume == object.volume) &&
            (self.calories == object.calories) &&
            (self.fats == object.fats) &&
            (self.proteins == object.proteins) &&
            (self.carbohydrates == object.carbohydrates) &&
            (self.containGluten == object.containGluten) &&
            (self.containLactose == object.containLactose)
        else { return false }

        return (self.dateRemovedFromFridge == nil) && (object.dateRemovedFromFridge == nil)
    }
}
