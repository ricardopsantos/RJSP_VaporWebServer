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
                    tableNames = "\(tableNames)[\(tableName)], "
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
                    DevTools.Logs.log(error:"\(DatabaseManager.self) error: \(error)", app: nil)
                    return nil
                } catch {
                    DevTools.Logs.log(error:"\(DatabaseManager.self) error: \(error)", app: nil)
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
    
    struct CRUD {
        private init() { }
        
        /// Get record with id
        static func get<T:Model>(_ record:T.Type, id :T.IDValue, using db: Database) throws -> EventLoopFuture<T> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return T.find(id, on: db).unwrap(or: Abort(.notFound)).map{ $0 }
        }
        
        /// Delete record if exists
        static func delete<T:Model>(_ record:T.Type, id :T.IDValue, using db: Database) throws -> EventLoopFuture<Void> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return try get(record, id: id, using: db).flatMap { $0.delete(on: db) }
        }

        /// Create new record
        static func create<T:Model>(_ record:T, using db: Database) throws -> EventLoopFuture<T> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return record.create(on: db).map { record }
        }
        
        /// Update (if exists), else create
        static func save<T:Model>(_ record:T, using db: Database) throws -> EventLoopFuture<T> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return record.save(on: db).map { record }
        }
        
        static func update<T:Model>(_ record:T, using db: Database) throws -> EventLoopFuture<T> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return record.update(on: db).map { record }
        }
        
        /// Get all records
        static func all<T: Model>(from:T.Type, using db: Database) throws -> EventLoopFuture<[T]> {
            guard DatabaseManager.ready else {
                DevTools.Logs.log(message: "DB not ready", app: nil)
                throw Abort(.internalServerError)
            }
            return from.query(on: db).all()
        }
          
    }
}
