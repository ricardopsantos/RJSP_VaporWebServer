//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public struct Utils { private init() { } }

public extension Utils {
    static func isProductionEnv(_ app: Application) -> Bool { return app.environment == .production }
    static func isDevelopmentEnv(_ app: Application) -> Bool { return app.environment == .development }
    static func isRestingEnv(_ app: Application) -> Bool { return app.environment == .testing }
}
