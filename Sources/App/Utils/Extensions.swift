//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public extension Request {
    func log(_ app: Application) {
        LogsManager.log(message: "\(self)", app: app)
    }
}

public extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

