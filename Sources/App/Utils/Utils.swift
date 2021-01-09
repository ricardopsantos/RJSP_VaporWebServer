//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public struct Utils { private init() { } }

public extension Utils {
    struct Strings {
        private init() { }
        static let pathConventionId = "id"
    }
}

public extension Utils {
    static func isProductionEnv(_ app: Application) -> Bool { return app.environment == .production }
    static func isDevelopmentEnv(_ app: Application) -> Bool { return app.environment == .development }
    static func isRestingEnv(_ app: Application) -> Bool { return app.environment == .testing }
}
