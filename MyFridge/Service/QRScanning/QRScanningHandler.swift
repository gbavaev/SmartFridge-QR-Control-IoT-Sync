import Foundation
import CodeScanner

struct QRScanningHandler {

    typealias QRResult = (
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
    )

    static func handle(
        _ response: Result<ScanResult, ScanError>,
        scanningType: QRScanningType,
        localManager: LocalManager,
        onProductDoesntExist: @escaping () -> Void,
        pathAdding: @escaping (FridgeItemModel) -> Void,
        onParsingError: @escaping (QRParsingError) -> Void
    ) {
        if case let .success(result) = response {
            do {
                let result: QRResult = try QRParser.parse(result.string)

                handleResult(
                    result: result,
                    scanningType: scanningType,
                    localManager: localManager,
                    onProductDoesntExist: onProductDoesntExist,
                    pathAdding: pathAdding
                )
            } catch {
                onParsingError(error)
                return
            }
        }
    }

    private static func handleResult(
        result: QRResult,
        scanningType: QRScanningType,
        localManager: LocalManager,
        onProductDoesntExist: @escaping () -> Void,
        pathAdding: @escaping (FridgeItemModel) -> Void
    ) {
        switch scanningType {
        case .adding:
            localManager.addFridgeItem(
                name: result.name,
                type: result.type,
                manufacturingDate: result.manufacturedDate,
                expirationDate: result.expirationDate,
                weight: result.weight,
                volume: result.volume,
                calories: result.calories,
                fats: result.fats,
                proteins: result.proteins,
                carbohydrates: result.carbohydrates,
                containGluten: result.containGluten,
                containLactose: result.containLactose
            )
        case .removing:
            localManager.removeFridgeItem(
                name: result.name,
                type: result.type,
                manufacturingDate: result.manufacturedDate,
                expirationDate: result.expirationDate,
                weight: result.weight,
                volume: result.volume,
                calories: result.calories,
                fats: result.fats,
                proteins: result.proteins,
                carbohydrates: result.carbohydrates,
                containGluten: result.containGluten,
                containLactose: result.containLactose
            ) { onProductDoesntExist() }
        case .gettingInfo:
            if let item = localManager.getItemIfExists(
                name: result.name,
                type: result.type,
                manufacturingDate: result.manufacturedDate,
                expirationDate: result.expirationDate,
                weight: result.weight,
                volume: result.volume,
                calories: result.calories,
                fats: result.fats,
                proteins: result.proteins,
                carbohydrates: result.carbohydrates,
                containGluten: result.containGluten,
                containLactose: result.containLactose
            ) {
                delay(0.15) { pathAdding(item) }
            } else {
                onProductDoesntExist()
            }
        }
    }
}
