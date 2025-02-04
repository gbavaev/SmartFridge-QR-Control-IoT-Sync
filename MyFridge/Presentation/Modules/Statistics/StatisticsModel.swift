import Foundation

enum StatisticsPeriodType: String, Identifiable, CaseIterable {
    case day, week, month, year

    var id: String { rawValue }

    var days: Int {
        switch self {
        case .day: 1
        case .week: 7
        case .month: 30
        case .year: 365
        }
    }

    var title: String {
        switch self {
        case .day: "День"
        case .week: "Неделя"
        case .month: "Месяц"
        case .year: "Год"
        }
    }
}
