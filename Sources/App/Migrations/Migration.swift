import Fluent

struct DBMigration: Migration {
    
    static func setup(on database: Database) {
        
        let dbInfo = DatabaseUtils.Querying.dbInfo(database: database)
        LogsManager.log(message:"\(dbInfo)", app: nil)

        [TodoDBModel.self, LogsDBModel.self].forEach { some in
            do {
                try (some as! DataBaseSchemable.Type).createTable(on: database).wait()
            } catch {
                LogsManager.log(error: "\(some.self) [\(error)]", app: nil)
            }
        }
        
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let event1 = TodoDBModel.createTable(on: database)
        let event2 = LogsDBModel.createTable(on: database)
        return event1
            .flatMap { event2 }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        let event1 = database.schema(TodoDBModel.schema).delete()
        let event2 = database.schema(LogsDBModel.schema).delete()
        return event1
            .flatMap { event2 }
    }
}

