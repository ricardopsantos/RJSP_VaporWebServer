
import Foundation
import Vapor
import Fluent

protocol DataBaseSchemableProtocol {
    static func createTable(on database: Database) -> EventLoopFuture<Void>
}

protocol RoutableCRUDPath {
    static var crudPath: String { get }
    static var pathComponent: PathComponent { get }
}

extension RoutableCRUDPath {
    static var pathComponent: PathComponent { return PathComponent(stringLiteral: crudPath) }
}
