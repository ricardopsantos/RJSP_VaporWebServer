import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let mainGroup = routes.grouped(TodoDBModel.path)

        // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.get(use: initialPath)
        
        // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
        mainGroup.post(use: saveNewRecord)
        
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.delete(use: deleteRecord)
        }
        mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
            some in some.get(use: getRecord)
        }
    }
}

//
// MARK :- Operations
//

private extension TodoController {
    
    private func initialPath(req: Request) throws -> EventLoopFuture<[TodoDBModel]> {
        return DatabaseManager.Querying.allRecords(from: TodoDBModel.self, using: req.db)
    }

    private func saveNewRecord(req: Request) throws -> EventLoopFuture<TodoDBModel> {
        let record = try req.content.decode(TodoDBModel.self)
        return DatabaseManager.Querying.saveRecord(record, using: req.db)
    }

    private func getRecord(req: Request) throws -> EventLoopFuture<TodoDBModel> {
        guard let paramId = req.parameters.get(Utils.Strings.pathConventionId),
              let recordId = UUID(paramId) else {
            throw Abort(.badRequest)
        }
        return TodoDBModel.find(recordId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .map{ $0 }
    }
    
    private func deleteRecord(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let paramId = req.parameters.get(Utils.Strings.pathConventionId),
              let recordId = UUID(paramId) else {
            throw Abort(.badRequest)
        }
        return TodoDBModel.find(recordId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
