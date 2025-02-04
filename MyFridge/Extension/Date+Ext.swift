import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
    }
}

extension Date {
    var startOfDate: Date {
        Calendar.current.startOfDay(for: self)
    }

    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? .now
    }

    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
}

extension Date {
    func asDay() -> String {
        self.formatted(date: .abbreviated, time: .omitted)
    }
}
