import Vapor
import Fluent

enum BaseCRUDControllerOperations: Int {
    case all
    case get
    case add
    case delete
}

/// Basic CRUD operations on `Todo`s.

class BaseCRUDController {
        
    var validOperations: [BaseCRUDControllerOperations] = [.get]
    
    static func allRecords<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<[T]> {
        return try DatabaseUtils.CRUD.all(from: from.self, using: req.db)
    }

    static func saveRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        let record = try req.content.decode(from.self)
        return try DatabaseUtils.CRUD.save(record, using: req.db)
    }

    static func getRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<T> {
        guard let requesParamUUID = req.paramUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return try DatabaseUtils.CRUD.get(from, id: id, using: req.db)
    }
    
    static func deleteRecord<T: Model>(from:T.Type, req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let requesParamUUID = req.paramUUID, let id = requesParamUUID as? T.IDValue  else { throw Abort(.badRequest) }
        return try DatabaseUtils.CRUD.delete(from, id: id, using: req.db).transform(to: .ok)
    }
}


class GenericBaseCRUDController<T: Model & RoutableCRUDPath & Content>: BaseCRUDController, RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let pathComponent = T.pathComponent
        let mainGroup = routes.grouped(pathComponent)

        guard validOperations.count > 0 else {
            DevTools.Logs.log(error: "No valid operations [\(BaseCRUDControllerOperations.self)] where given. Ignored", app: nil)
            return
        }
        
        DevTools.Logs.log(message: "Will create routes at \\\(pathComponent)", app: nil)

        let hasGetPermission = validOperations.contains(.get) || validOperations.contains(.all)
        let hasSavePermission = validOperations.contains(.add) || validOperations.contains(.all)

        if hasGetPermission {
            // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE
            mainGroup.get { (req) -> EventLoopFuture<[T]> in
                guard req.isValid else { throw Abort(.unauthorized) }
                return try Self.allRecords(from: T.self, req: req)
            }
        }

        if hasSavePermission {
            // HTTP POST : SERVER_PATH:PORT/INITIAL_ROUTE
            mainGroup.post { (req) -> EventLoopFuture<T> in
                guard req.isValid else { throw Abort(.unauthorized) }
                return try Self.saveRecord(from: T.self, req: req)
            }
        }

        if validOperations.contains(.get) || validOperations.contains(.all) {
            mainGroup.group("operations", ":\(DevTools.Strings.pathConventionId)") {
                // HTTP GET : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.get{ (req) -> EventLoopFuture<T> in
                    guard req.isValid else { throw Abort(.unauthorized) }
                    return try Self.getRecord(from: T.self, req: req)
                }
            }
        }

        if validOperations.contains(.add) || validOperations.contains(.all) {
            mainGroup.group("operations", ":\(DevTools.Strings.pathConventionId)") {
                // HTTP DELETE : SERVER_PATH:PORT/INITIAL_ROUTE/operations/someId
                some in some.delete{ (req) -> EventLoopFuture<HTTPStatus> in
                    guard req.isValid else { throw Abort(.unauthorized) }
                    return try Self.deleteRecord(from: T.self, req: req)
                }
            }
        }

    }
}
