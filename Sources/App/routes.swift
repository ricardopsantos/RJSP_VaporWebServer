import Vapor

//
// https://docs.vapor.codes/4.0/routing/
//

func routes(_ app: Application) throws {
    
    //
    // SERVER_PATH:PORT
    // GET: Main page
    //
    app.get { req -> String in
        req.log(app)
        return "Hello stranger!\n\nChoose wishly:\n* https://www.linkedin.com/in/ricardopsantos\n* https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    }
    
    //
    // SERVER_PATH:PORT/version
    // GET: Server Version
    //
    app.get("version") { req -> String in
        req.log(app)
        guard req.isValid else { throw Abort(.unauthorized) }
        return "Version 1.0.1\n\(app.environment)"
    }
    
    //
    // SERVER_PATH:PORT/configuration
    // GET: Server Configuration for clients
    //
    app.get("configuration") { req -> EventLoopFuture<[KeyValueDBModel]> in
        guard req.isValid else { throw Abort(.unauthorized) }
        req.log(app)
        return try DatabaseUtils.CRUD.all(from: KeyValueDBModel.self, using: req.db)
    }
        
    //
    // SERVER_PATH:PORT/hello/YOUR_NAME
    // GET: Sample route with request parameter
    //
    app.get("hello", ":\(DevTools.Strings.pathConventionParam)") { req -> String in
        guard req.isValid else { throw Abort(.unauthorized) }
        req.log(app)
        guard let name = req.paramValueForFieldWith(DevTools.Strings.pathConventionParam) else { throw Abort(.internalServerError) }
        return "Hello \(name)"
    }
    
    //
    // SERVER_PATH:PORT/login
    // (POST: Sample login)
    //
    app.post("login") { req -> EventLoopFuture<UsersDBModel> in
        guard req.isValid else { throw Abort(.unauthorized) }
        req.log(app)
        let user = try req.content.decode(UsersDBModel.self)
        let storedUserMaybe = UsersDBModel.userWith(username: user.username, password: user.password, on: req.db)
        return storedUserMaybe.unwrap(or: Abort(.notFound)).map { $0 }
    }
  
    //
    let collection_Config = GenericBaseCRUDController<KeyValueDBModel>()
    collection_Config.validOperations = [.get]
    try app.register(collection: collection_Config)

    //
    let collection_Logs = GenericBaseCRUDController<LogsDBModel>()
    collection_Logs.validOperations = [.add, .get]
    try app.register(collection: collection_Logs)

    let collection_Todo = GenericBaseCRUDController<TodoDBModel>()
    collection_Todo.validOperations = [.all]
    try app.register(collection: collection_Todo)

}

