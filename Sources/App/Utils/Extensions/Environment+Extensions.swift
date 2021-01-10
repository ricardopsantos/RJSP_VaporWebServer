//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

