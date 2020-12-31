//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation
//import RJSLibUFBase

public struct ConfigManager { private init() { } }

extension String {
//    var aesDecrypted: String { return "error" }
}

public extension ConfigManager {
    
    static func valueWith(key: String) -> String {
        if let value = Environment.get(key), !value.isEmpty {
            return value
        }
        return "not_found"
    }
}

