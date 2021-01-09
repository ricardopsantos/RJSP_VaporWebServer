import Foundation
import Vapor
import Logging
import PostgresKit
import Fluent
import FluentPostgresDriver

public extension DatabaseManager {
    
    struct Querying {
        private init() { }
        
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
        static func allRecords<T>(from:T.Type, using db: Database) -> EventLoopFuture<[T]> where T: Model {
            from.query(on: db).all()
        }
          
    }
}
