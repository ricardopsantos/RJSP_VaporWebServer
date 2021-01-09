import Foundation
import Vapor
import Logging
import PostgresKit
import Fluent
import FluentPostgresDriver

public struct DatabaseUtils {
    private init() { }
}

public extension DatabaseUtils {
    
    struct Querying {
        private init() { }
        
        static func dbInfo(database: Database) -> String {
            let query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
            let result = execute(query: query, on: database)
            var tableNames = "Tables: "
            result?.rows.forEach({ (row) in
                if let tableName = row.column("table_name")?.string {
                    tableNames = "\(tableNames)\(tableName), "
                }
            })
            return tableNames
        }
        //
        //
        //
        static func execute(query: String, on db: Database) -> PostgresQueryResult? {
            func execute(query: String, postgresDatabase: PostgresDatabase) -> PostgresQueryResult? {
                do {
                    return try postgresDatabase.query(query).wait()
                } catch let error as DatabaseError where error.isSyntaxError {
                    LogsManager.log(error:"\(DatabaseManager.self) error: \(error)", app: nil)
                    return nil
                } catch {
                    LogsManager.log(error:"\(DatabaseManager.self) error: \(error)", app: nil)
                    return nil
                }
            }
            
            if let postgresDatabase = db as? PostgresDatabase {
                return execute(query: query, postgresDatabase: postgresDatabase)
            }
            return nil
        }
        
        //
        //
        //
        static func execute(query: String, on db: Database, callback: @escaping (PostgresQueryResult?) -> Void) {
            if let postgresDatabase = db as? PostgresDatabase {
                postgresDatabase.query(query).whenSuccess({ (result) in callback(result) })
            } else {
                callback(nil)
            }
        }
    }
    
}

public extension DatabaseUtils {
    
    struct BasicOperations {
        private init() { }
        
        //
        //
        //
        static func getRecord<T:Model>(_ record:T.Type, id :T.IDValue, using db: Database) -> EventLoopFuture<T> {
            return T.find(id, on: db).unwrap(or: Abort(.notFound)).map{ $0 }
        }
        
        //
        //
        //
        static func deleteRecord<T:Model>(_ record:T.Type, id :T.IDValue, using db: Database) -> EventLoopFuture<Void> {
            return getRecord(record, id: id, using: db).flatMap { $0.delete(on: db) }
        }

        //
        //
        //
        static func createRecord<T:Model>(_ record:T, using db: Database) -> EventLoopFuture<T> {
            record.create(on: db).map { record }
        }
        
        //
        //
        //
        static func saveRecord<T:Model>(_ record:T, using db: Database) -> EventLoopFuture<T> {
            record.save(on: db).map { record }
        }
        
        //
        //
        //
        static func allRecords<T: Model>(from:T.Type, using db: Database) -> EventLoopFuture<[T]> {
            from.query(on: db).all()
        }
          
    }
}
