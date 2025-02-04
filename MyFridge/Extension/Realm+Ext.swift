import RealmSwift

extension Realm {
    func perform(_ action: () -> Void) {
        do {
            try self.write {
                action()
            }
        } catch {
            logger.error("Error while writing to Realm: \(error.localizedDescription)")
        }
    }
}
