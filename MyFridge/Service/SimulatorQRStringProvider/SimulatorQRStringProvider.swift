import Foundation

final class SimulatorQRStringProvider {
    static func provide() -> String {
        #if targetEnvironment(simulator)
            logger.trace("DEBUG: Current environment is simulator")

            return [
                "боржоми, Вода, 14.12.2024, 21.12.2024, 300, 0.027, 300, 7, 5, 30, 0, 0",
                "шоколадка, Вкусняшка, 13.11.2024, 11.12.2024, 200, 0.027, 300, 7, 5, 30, 1, 1",
                "не шоколадка, Вкусняшка, 13.11.2024, 31.12.2024, 200, 0.027, 300, 7, 5, 30, 0, 1",
                "абоба, Абоба, 13.11.2024, 31.12.2024, 200, 0.027, 300, 7, 5, 30, 1, 0",
                "не боржоми, Вкусняшка, 13.10.2024, 2.12.2024, 200, 0.027, 300, 7, 5, 30, 0, 0"
            ].randomElement()!
        #else
            return ""
        #endif
    }
}
