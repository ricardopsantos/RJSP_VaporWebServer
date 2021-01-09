
import Foundation
import Vapor
import Fluent

protocol DataBaseSchemable {
    static func createTable(on database: Database) -> EventLoopFuture<Void>
}

protocol RoutablePathProtocol {
    static var initialPath: String { get }
    static var path: PathComponent { get }
}

extension RoutablePathProtocol {
    static var path: PathComponent { return PathComponent(stringLiteral: initialPath) }
}
