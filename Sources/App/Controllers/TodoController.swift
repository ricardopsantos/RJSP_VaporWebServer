import Fluent
import Vapor

class GenericController<T: Model & Routable & Content>: BaseRoutingController, RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let mainGroup = routes.grouped(T.path)

        // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.get { (req) -> EventLoopFuture<[T]> in
            try Self.allRecords(from: T.self, req: req)
        }
        
        // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.post { (req) -> EventLoopFuture<T> in
            try Self.saveRecord(from: T.self, req: req)
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.get{ (req) -> EventLoopFuture<T> in
                try Self.getRecord(from: T.self, req: req)
            }
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                try Self.deleteRecord(from: T.self, req: req)
            }
        }
    }
}

class TodoController: BaseRoutingController, RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let mainGroup = routes.grouped(TodoDBModel.path)

        // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.get { (req) -> EventLoopFuture<[TodoDBModel]> in
            try Self.allRecords(from: TodoDBModel.self, req: req)
        }
        
        // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.post { (req) -> EventLoopFuture<TodoDBModel> in
            try Self.saveRecord(from: TodoDBModel.self, req: req)
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.get{ (req) -> EventLoopFuture<TodoDBModel> in
                try Self.getRecord(from: TodoDBModel.self, req: req)
            }
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                try Self.deleteRecord(from: TodoDBModel.self, req: req)
            }
        }
    }
}

//
// MARK :- Operations
//

class BaseRoutingController {
    
    static func allRecords<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<[T]> {
        return DatabaseUtils.BasicOperations.allRecords(from: from.self, using: req.db)
    }

    static func saveRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        let record = try req.content.decode(from.self)
        return DatabaseUtils.BasicOperations.saveRecord(record, using: req.db)
    }

    static func getRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return DatabaseUtils.BasicOperations.getRecord(from, id: id, using: req.db)
    }
    
    static func deleteRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return DatabaseUtils.BasicOperations.deleteRecord(from, id: id, using: req.db).transform(to: .ok)
    }
}
