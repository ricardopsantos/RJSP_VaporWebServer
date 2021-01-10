import Fluent
import Vapor

enum BaseCRUDOperations: Int {
    case all
    case get
    case add
    case delete
}

/// Basic CRUD operations on `Todo`s.

class BaseCRUDController {
        
    var validOperations: [BaseCRUDOperations] = [.get]
    
    static func allRecords<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<[T]> {
        return try DatabaseUtils.CRUD.all(from: from.self, using: req.db)
    }

    static func saveRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        let record = try req.content.decode(from.self)
        return try DatabaseUtils.CRUD.save(record, using: req.db)
    }

    static func getRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return try DatabaseUtils.CRUD.get(from, id: id, using: req.db)
    }
    
    static func deleteRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let requesParamUUID = req.requesParamUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return try DatabaseUtils.CRUD.delete(from, id: id, using: req.db).transform(to: .ok)
    }
}


class GenericBaseCRUDController<T: Model & RoutablePathProtocol & Content>: BaseCRUDController, RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeBasePath = T.path
        let mainGroup = routes.grouped(routeBasePath)

        guard validOperations.count > 0 else {
            DevTools.Logs.log(error: "No valid operations [\(BaseCRUDOperations.self)] where given. Ignored", app: nil)
            return
        }
        
        DevTools.Logs.log(message: "Will create routes at \\\(routeBasePath)", app: nil)

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
            mainGroup.group("operations", ":\(DevTools.Strings.pathConventionId)") {
                // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.get{ (req) -> EventLoopFuture<T> in
                    try Self.getRecord(from: T.self, req: req)
                }
            }
        }

        if validOperations.contains(.add) || validOperations.contains(.all) {
            mainGroup.group("operations", ":\(DevTools.Strings.pathConventionId)") {
                // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                    try Self.deleteRecord(from: T.self, req: req)
                }
            }
        }

    }
}
