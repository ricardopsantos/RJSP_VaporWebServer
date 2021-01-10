//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

// Quick getter for request values
public extension Request {
    
    /// Returns the client key from the request header
    var headerClientKeyValue: String? {
        headerValueForFieldWith("CLIENT_KEY")
    }
    
    /// Returns the STRING pararm with id = DevTools.Strings.pathConventionId
    var paramString: String? {
        return paramValueForFieldWith(DevTools.Strings.pathConventionId)
    }
    
    /// Returns the UUID pararm with id = DevTools.Strings.pathConventionId
    var paramUUID: UUID? {
        guard let requesParamString = paramString else { return nil }
        return UUID(requesParamString)
    }
    
}

public extension Request {
    
    /// Validates if the request have a valid client key on the header
    var isValid: Bool {
        guard let clientKeyValue = ConfigManager.valueWith(key: "CLIENT_KEY") else {
            // No client key defined on Environment, so all requests are valid.
            return true
        }
        guard let headerClientKeyValue = headerClientKeyValue else {
            // Request is missing client key.
            return false
        }
        return clientKeyValue.lowercased() == headerClientKeyValue.lowercased()
    }
    
    func headerValueForFieldWith(_ id: String) -> String? {
        return self.headers.first(name: id)
    }
    
    func paramValueForFieldWith(_ id: String) -> String? {
        return self.parameters.get(id)
    }
    

    
    /// Logs the request
    func log(_ app: Application?) {
        DevTools.Logs.log(message: "\(self)", app: app)
    }
}
