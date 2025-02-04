import Foundation

enum QRParsingError: Error {
    case invalidData, invalidFormat, invalidDate

    var localizedDescription: String {
        switch self {
        case .invalidData: "Ошибка обработки QR кода: неправильно введенные данные"
        case .invalidFormat: "Ошибка обработки QR кода: неправильный формат данных"
        case .invalidDate: "Ошибка обработки QR кода: неправильный формат даты"
        }
    }
}
