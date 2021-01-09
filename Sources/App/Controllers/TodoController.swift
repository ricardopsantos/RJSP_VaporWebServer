import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let mainGroup = routes.grouped(TodoDBModel.path)

        // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.get { (req) -> EventLoopFuture<[TodoDBModel]> in
            try initialPath(from: TodoDBModel.self, req: req)
        }
        
        // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.post { (req) -> EventLoopFuture<TodoDBModel> in
            try saveNewRecord(from: TodoDBModel.self, req: req)
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.get{ (req) -> EventLoopFuture<TodoDBModel> in
                try getRecord(from: TodoDBModel.self, req: req)
            }
        }
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                try deleteRecord(from: TodoDBModel.self, req: req)
            }
        }
    }
}

//
// MARK :- Operations
//

private extension TodoController {
    
    private func initialPath<T>(from:T.Type, req: Request) throws -> EventLoopFuture<[T]> where T: Model {
        return DatabaseManager.Querying.allRecords(from: from.self, using: req.db)
    }

    private func saveNewRecord<T>(from:T.Type, req: Request) throws -> EventLoopFuture<T> where T: Model {
        let record = try req.content.decode(from.self)
        return DatabaseManager.Querying.saveRecord(record, using: req.db)
    }

    private func getRecord<T>(from:T.Type, req: Request) throws -> EventLoopFuture<T> where T: Model {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return from.self.find(id, on: req.db)
            .unwrap(or: Abort(.notFound)).map{ $0 }
    }
    
    private func deleteRecord<T>(from:T.Type, req: Request) throws -> EventLoopFuture<HTTPStatus> where T: Model {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return from.self.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
