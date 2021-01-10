import Fluent

struct DBMigration: Migration {
    
    static func setup(on database: Database) {
        
        let dbInfo = DatabaseUtils.Querying.dbInfo(database: database)
        DevTools.Logs.log(message:"\(dbInfo)", app: nil)

        [TodoDBModel.self, LogsDBModel.self, UsersDBModel.self].forEach { some in
            do {
                if let dataBaseSchemable = some as? DataBaseSchemableProtocol.Type {
                    try dataBaseSchemable.createTable(on: database).wait()
                } else {
                    DevTools.Logs.log(error: "\(some.self) does not conform to \(DataBaseSchemableProtocol.self)", app: nil)
                }
            } catch {
                DevTools.Logs.log(error: "\(some.self) [\(error)]", app: nil)
            }
        }
        
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let event1 = TodoDBModel.createTable(on: database)
        let event2 = LogsDBModel.createTable(on: database)
        let event3 = UsersDBModel.createTable(on: database)
        return event1
            .flatMap { event2 }
            .flatMap { event3 }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        let event1 = database.schema(TodoDBModel.schema).delete()
        let event2 = database.schema(LogsDBModel.schema).delete()
        let event3 = database.schema(UsersDBModel.schema).delete()
        return event1
            .flatMap { event2 }
            .flatMap { event3 }
    }
}

