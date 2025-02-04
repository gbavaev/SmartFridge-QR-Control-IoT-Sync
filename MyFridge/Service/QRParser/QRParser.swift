import Foundation

final class QRParser {
    static func parse(_ result: String) throws (QRParsingError) -> (
        name: String,
        type: String,
        manufacturedDate: Date,
        expirationDate: Date,
        weight: Int,
        volume: Double,
        calories: Int,
        proteins: Int,
        fats: Int,
        carbohydrates: Int,
        containGluten: Bool,
        containLactose: Bool
    ) {
        logger.trace("DEBUG: Successfully scanned QR code. Initial string: \(result)")

        let components = result.removeExtraSpaces().split(separator: ", ")

        guard components.count == 12 else { throw .invalidFormat }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let name = String(components[0])
        let type = String(components[1])

        guard let manufacturedDate = dateFormatter.date(from: String(components[2]))?.startOfDate else {
            throw .invalidDate
        }

        guard let expirationDate = dateFormatter.date(from: String(components[3]))?.startOfDate else {
            throw .invalidDate
        }

        guard let weight = Int(components[4]) else { throw .invalidData }
        guard let volume = Double(components[5]) else { throw .invalidData }

        guard let calories = Int(components[6]) else { throw .invalidData }
        guard let proteins = Int(components[7]) else { throw .invalidData }
        guard let fats = Int(components[8]) else { throw .invalidData }
        guard let carbohydrates = Int(components[9]) else { throw .invalidData }

        guard let containGluten = Int(components[10])?.bool else { throw .invalidData }
        guard let containLactose = Int(components[11])?.bool else { throw .invalidData }

        return (
            name: name,
            type: type,
            manufacturedDate: manufacturedDate,
            expirationDate: expirationDate,
            weight: weight,
            volume: volume,
            calories: calories,
            proteins: proteins,
            fats: fats,
            carbohydrates: carbohydrates,
            containGluten: containGluten,
            containLactose: containLactose
        )
    }
}
