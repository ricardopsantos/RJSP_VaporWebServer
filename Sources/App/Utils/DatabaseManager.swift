import Foundation
import Vapor
import Logging
import PostgresKit
import Fluent
import FluentPostgresDriver

extension DatabaseID {
    struct DB1 {
        private init() { }
        static let id = DatabaseID(string: "db1.id")
        private static let connectionStringEnvKey = "DB1_CONNECTION_STRING"
        static let connectionString = ConfigManager.valueWith(key: connectionStringEnvKey)
    }
    struct DB2 {
        private init() { }
        static let id = DatabaseID(string: "db2.id")
        private static let connectionStringEnvKey = "DB2_CONNECTION_STRING"
        static let connectionString = ConfigManager.valueWith(key: connectionStringEnvKey)
    }
    struct DB3 {
        private init() { }
        static let id = DatabaseID(string: "db2.id")
        private static let connectionStringEnvKey = "DB2_CONNECTION_STRING"
        static let connectionString = ConfigManager.valueWith(key: connectionStringEnvKey)
    }
}

//
// https://docs.vapor.codes/4.0/fluent/overview/
// https://docs.vapor.codes/4.0/fluent/query/
//

public class DatabaseManager {
    private init() { }
    private static var dbReady: Bool = false
    public static var ready: Bool { dbReady }
}
 
// MARK: - public

public extension DatabaseManager {
        
    static func setup(app: Application) {
        guard !dbReady else { return }
        do {
            try app.databases.use(.postgres(url: DatabaseID.DB1.connectionString), as: DatabaseID.DB1.id)
            dbReady = true
            DatabaseManager.doTest(app: app)
        } catch {
            LogsManager.log(error: "\(DatabaseManager.self) [\(error)] [\(DatabaseID.DB1.connectionString)]", app: app)
        }
    }
    
    static func shutdownGracefully(_ app: Application? = nil) {
        guard dbReady else { return }
        LogsManager.log(error: "\(DatabaseManager.self) will shutdown", app: app)
        app?.databases.shutdown()
        dbReady = false
    }
    
    static func doTest(app: Application) {
        guard dbReady else { return }
        do {
            let test1Result = try KeyValueDBModel.query(on: app.db).all().wait()
            LogsManager.log(message: "DB connection: test1Result - sucess \(test1Result)", app: app)
            
            let test2Result = DatabaseUtils.Querying.execute(query: "SELECT * FROM \(KeyValueDBModel.schema)", on: app.db)
            LogsManager.log(message: "DB connection: test2Result - sucess \(String(describing: test2Result))", app: app)
            
            DatabaseUtils.Querying.execute(query: "SELECT * FROM \(KeyValueDBModel.schema)", on: app.db) { [weak app] (test3Result) in
                if let test3Result = test3Result {
                    LogsManager.log(message: "DB connection: test3Result - sucess \(test3Result)", app: app)
                } else {
                    LogsManager.log(message: "DB connection: test2Result - fail", app: app)
                }
            }

        } catch {
            LogsManager.log(error: "Fail connection DB [\(error)]", app: app)
        }
    }
}
