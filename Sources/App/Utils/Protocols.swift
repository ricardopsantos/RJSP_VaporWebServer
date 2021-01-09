
import Foundation
import Vapor

protocol Routable {
    static var initialPath: String { get }
    static var path: PathComponent { get }
}

extension Routable {
    static var path: PathComponent { return PathComponent(stringLiteral: initialPath) }
}
