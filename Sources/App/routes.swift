import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

struct AutenticationModel: Content {
  let user: String
  let password: String
}

struct Hello: Content {
    var name: String?
}

// https://docs.vapor.codes/4.0/routing/

func returnWith(_ some: Any) -> String {
    return "\(some)"
}

func routes(_ app: Application) throws {
    
    //
    // SERVER_PATH:PORT
    // (GET: Main page)
    //
    app.get { req -> String in
        req.log(app)
        return returnWith("Hello stranger!\n\nChoose wishly:\n* https://www.linkedin.com/in/ricardopsantos\n* https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    }
    
    //
    // SERVER_PATH:PORT/version
    // (GET: Server Version)
    //
    app.get("version") { req -> String in
        req.log(app)
        let version = "Version 1.0.0"
        return returnWith("\(version)\n\n\(app.environment)")
    }
    
    //
    // SERVER_PATH:PORT/configuration
    // (GET: Server Configuration for clients)
    //
    app.get("configuration") { req -> EventLoopFuture<[DBKeyValue]> in
        req.log(app)
        guard DatabaseManager.ready else {
            LogsManager.log(message: "DB not ready", app: app)
            throw Abort(.internalServerError)
        }
        let response1 = DatabaseManager.Querying.allRecords(from: DBKeyValue.self, using: req.db)
        let response2 = DatabaseManager.Querying.allRecords(from: DBKeyValue.self, using: app.db)
        return Bool.random() ? response1 : response2 // Booth work
    }
    
    //
    // SERVER_PATH:PORT/configuration/add
    //
    app.get("configuration", "add") { req -> EventLoopFuture<DBKeyValue> in
        req.log(app)
        let record = DBKeyValue(key: "aKey_\(Date())", encoding: "1", value: "value")
        return DatabaseManager.Querying.addRecord(record, using: req.db)
    }
    
    //
    // SERVER_PATH:PORT/logs
    //
    app.get("logs") { req -> EventLoopFuture<[DBLogs]> in
        req.log(app)
        guard DatabaseManager.ready else {
            LogsManager.log(message: "DB not ready", app: app)
            throw Abort(.internalServerError)
        }
        let response1 = DatabaseManager.Querying.allRecords(from: DBLogs.self, using: req.db)
        let response2 = DatabaseManager.Querying.allRecords(from: DBLogs.self, using: app.db)
        return Bool.random() ? response1 : response2 // Booth work
    }
    
    //
    // SERVER_PATH:PORT/hello/ricardo
    // (GET: Sample route with static path)
    //
    app.get("hello", "ricardo") { req -> String in
        req.log(app)
        return returnWith("Hello boss!")
    }
    
    //
    // SERVER_PATH:PORT/hello/YOUR_NAME
    // (GET: Sample route with request parameter)
    //
    app.get("hello", ":someParam") { req -> String in
        req.log(app)
        guard let name = req.parameters.get("someParam") else { throw Abort(.internalServerError) }
        return returnWith("Hello \(name)")
    }
    
    //
    // SERVER_PATH:PORT/login
    // (POST: Sample login)
    //
    app.post("login") { req -> String in
        req.log(app)
        let data = try req.content.decode(AutenticationModel.self)
        if data.password == "1" && data.user.lowercased() == "Ricardo".lowercased() {
            return  returnWith("Hello \(data.user)")
        } else {
            return  returnWith("Go away \(req)")
        }
    }
    
    app.post("login") { req -> String in
        req.log(app)
        let data = try req.content.decode(AutenticationModel.self)
        if data.password == "1" && data.user.lowercased() == "Ricardo".lowercased() {
            return  returnWith("Hello \(data.user)")
        } else {
            return  returnWith("Go away \(req)")
        }
    }
    

}
