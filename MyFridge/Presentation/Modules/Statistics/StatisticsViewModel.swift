import Foundation
import RealmSwift
import SwiftUI

final class StatisticsViewModel: ObservableObject {

    @Published var addedFridgeItems: [FridgeItemUIModel] = []
    @Published var removedFridgeItems: [FridgeItemUIModel] = []

    @Published var selectedPeriod: StatisticsPeriodType = .day
    @Published var endOfPeriod: Date = .now

    @AppStorage("showRemovedProductsStatistics") var showRemovedProductsStatistics: Bool = true

    var hasAppeared: Bool = false // fix swiftui underhood mechanisms

    private let realm: Realm
    private let calendar: Calendar

    init() {
        realm = try! Realm()
        calendar = .current

        logger.info("DEBUG: Successfully initialized Realm in StatisticsViewModel")
    }

    func getAddedFridgeItems(filter: StatisticsPeriodType, endOfPeriod: Date) {
        var objects = Array(realm.objects(FridgeItemModel.self).reversed())

        let startDate = (calendar.date(byAdding: .day, value: -filter.days + 1, to: endOfPeriod) ?? endOfPeriod).startOfDate

        objects = objects.filter({
            $0.dateAddedToFridge >= startDate && $0.dateAddedToFridge <= endOfPeriod
        })

        objects = objects.sorted(by: { lhs, rhs in
            lhs.dateAddedToFridge > rhs.dateAddedToFridge
        })

        var existingItems: [FridgeItemUIModel] = []

        for object in objects {
            if let index = existingItems.firstIndex(where: {
                $0.product.isExistingEqualAsUIModel(to: object) &&
                calendar.isDate($0.product.dateAddedToFridge, inSameDayAs: object.dateAddedToFridge)
            }) {
                existingItems[index].count += 1
            } else {
                existingItems.append(.init(product: object, count: 1))
            }
        }

        self.addedFridgeItems = existingItems
    }

    func getRemovedFridgeItems(filter: StatisticsPeriodType, endOfPeriod: Date) {
        var objects = Array(realm.objects(FridgeItemModel.self).filter({ $0.dateRemovedFromFridge != nil }).reversed())

        let startDate = (calendar.date(byAdding: .day, value: -filter.days + 1, to: endOfPeriod) ?? endOfPeriod).startOfDate

        objects = objects.filter({ item in
            if let date = item.dateRemovedFromFridge {
                return date >= startDate && date <= endOfPeriod
            }

            return false
        })

        objects = objects.sorted(by: { lhs, rhs in
            lhs.dateRemovedFromFridge! > rhs.dateRemovedFromFridge!
        })

        var removedItems: [FridgeItemUIModel] = []

        for object in objects {
            if let index = removedItems.firstIndex(where: { $0.product.isRemovedEqualAsUIModel(to: object) }) {
                removedItems[index].count += 1
            } else {
                removedItems.append(.init(product: object, count: 1))
            }
        }

        self.removedFridgeItems = removedItems
    }
}
