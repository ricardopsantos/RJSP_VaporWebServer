//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public struct LogsManager {
    static var count: Int = 0
    
    private static func finalMessage(_ prefix: String, _ message: String, _ file: String, _ function: String) -> String {
        count += 1
        let separator = "####################################################"
        let path = file.components(separatedBy: "/").last ?? ""
        let sender = "[\(function) @ \(path)]"
        let logCount = "Log_\(count)"
        return "\n\(separator)\n# \(Date())\n# \(prefix)\n# \(logCount)\n# \(sender)\n\(message)\n\(separator)"
    }
    
    public static func log(message: String, app: Application?, file: String = #file, function: String = #function) {
        let log = finalMessage("INFO", message, file, function)
        if let app = app, app.environment == .production {
            app.logger.info(Logger.Message(stringLiteral: log))
        }
        print(log)
    }
    
    public static func log(error: String, app: Application?, file: String = #file, function: String = #function) {
        let log = finalMessage("ERROR", error, file, function)
        if let app = app, app.environment == .production {
            app.logger.error(Logger.Message(stringLiteral: log))
        }
        print(log)
    }
}