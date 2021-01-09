import Fluent

struct TodoMigration: Migration {
    
    static func setup(on database: Database) {
        do {
            try TodoMigration.createTable(on: database).wait()
        } catch {
            LogsManager.log(error: "\(TodoMigration.self) [\(error)]", app: nil)
        }
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return TodoMigration.createTable(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(TodoDBModel.schema).delete()
    }
}

extension TodoMigration {
    private static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(TodoDBModel.schema)
            .id()
            .field("title", .string, .required)
            .create()
    }
}
