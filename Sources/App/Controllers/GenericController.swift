import Fluent
import Vapor

enum BaseRoutingControllerValidOperations: Int {
    case all
    case get
    case add
    case delete
}

class BaseRoutingController {
        
    var validOperations: [BaseRoutingControllerValidOperations] = [.get]
    
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


class GenericController<T: Model & RoutablePathProtocol & Content>: BaseRoutingController, RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeBasePath = T.path
        let mainGroup = routes.grouped(routeBasePath)

        guard validOperations.count > 0 else {
            LogsManager.log(error: "No valid operations [\(BaseRoutingControllerValidOperations.self)] where given. Ignored", app: nil)
            return
        }
        
        LogsManager.log(error: "Will create routes at \\\(routeBasePath)", app: nil)

        if validOperations.contains(.get) || validOperations.contains(.all) {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
            mainGroup.get { (req) -> EventLoopFuture<[T]> in
                try Self.allRecords(from: T.self, req: req)
            }
        }

        if validOperations.contains(.add) || validOperations.contains(.all) {
            // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
            mainGroup.post { (req) -> EventLoopFuture<T> in
                try Self.saveRecord(from: T.self, req: req)
            }
        }

        if validOperations.contains(.get) || validOperations.contains(.all) {
            mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
                // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.get{ (req) -> EventLoopFuture<T> in
                    try Self.getRecord(from: T.self, req: req)
                }
            }
        }

        if validOperations.contains(.add) || validOperations.contains(.all) {
            mainGroup.group("operations", ":\(Utils.Strings.pathConventionId)") {
                // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                    try Self.deleteRecord(from: T.self, req: req)
                }
            }
        }

    }
}
