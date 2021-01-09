import Fluent
import Vapor

//
// DEPRECATED
// DEPRECATED
// DEPRECATED

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
