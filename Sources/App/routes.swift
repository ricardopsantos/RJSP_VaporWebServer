import Vapor

func routes(_ app: Application) throws {
    
    //
    // SERVER_PATH:PORT
    // (GET: Main page)
    //
    app.get { req -> String in
        req.log(app)
        return "Hello stranger!\n\nChoose wishly:\n* https://www.linkedin.com/in/ricardopsantos\n* https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    }
    
    //
    // SERVER_PATH:PORT/version
    // (GET: Server Version)
    //
    app.get("version") { req -> String in
        req.log(app)
        let version = "Version 1.0.0"
        return "\(version)\n\n\(app.environment)"
    }
    
    //
    // SERVER_PATH:PORT/configuration
    // (GET: Server Configuration for clients)
    //
    app.get("configuration") { req -> EventLoopFuture<[KeyValueDBModel]> in
        req.log(app)
        guard DatabaseManager.ready else {
            LogsManager.log(message: "DB not ready", app: app)
            throw Abort(.internalServerError)
        }
        let response1 = DatabaseUtils.BasicOperations.allRecords(from: KeyValueDBModel.self, using: req.db)
        let response2 = DatabaseUtils.BasicOperations.allRecords(from: KeyValueDBModel.self, using: app.db)
        return Bool.random() ? response1 : response2 // Booth work
    }
    
    //
    // SERVER_PATH:PORT/configuration/add
    //
    app.get("configuration", "add") { req -> EventLoopFuture<KeyValueDBModel> in
        req.log(app)
        let record = KeyValueDBModel(key: "aKey_\(Date())", encoding: "1", value: "value")
        return DatabaseUtils.BasicOperations.createRecord(record, using: req.db)
    }
    
    //
    // SERVER_PATH:PORT/logs
    //
    app.get("logs") { req -> EventLoopFuture<[LogsDBModel]> in
        req.log(app)
        guard DatabaseManager.ready else {
            LogsManager.log(message: "DB not ready", app: app)
            throw Abort(.internalServerError)
        }
        let response1 = DatabaseUtils.BasicOperations.allRecords(from: LogsDBModel.self, using: req.db)
        let response2 = DatabaseUtils.BasicOperations.allRecords(from: LogsDBModel.self, using: app.db)
        return Bool.random() ? response1 : response2 // Booth work
    }
    
    //
    // SERVER_PATH:PORT/hello/ricardo
    // (GET: Sample route with static path)
    //
    app.get("hello", "ricardo") { req -> String in
        req.log(app)
        return "Hello boss!"
    }
    
    //
    // SERVER_PATH:PORT/hello/YOUR_NAME
    // (GET: Sample route with request parameter)
    //
    app.get("hello", ":someParam") { req -> String in
        req.log(app)
        guard let name = req.parameters.get("someParam") else { throw Abort(.internalServerError) }
        return "Hello \(name)"
    }
    
    //
    // SERVER_PATH:PORT/login
    // (POST: Sample login)
    //
    app.post("login") { req -> String in
        req.log(app)
        let data = try req.content.decode(AutenticationModel.self)
        if data.password == "1" && data.user.lowercased() == "Ricardo".lowercased() {
            return  "Hello \(data.user)"
        } else {
            return "Go away \(req)"
        }
    }
    
    //try app.register(collection: TodoController())
    //try app.register(collection: TestController<LogsDBModel>())
    try app.register(collection: GenericController<TodoDBModel>())

}





struct AutenticationModel: Content {
  let user: String
  let password: String
}

struct Hello: Content {
    var name: String?
}

// https://docs.vapor.codes/4.0/routing/
