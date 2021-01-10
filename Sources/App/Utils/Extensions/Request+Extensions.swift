//
//  Created by Ricardo Santos on 19/12/2020.
//

import Vapor
import Foundation

public extension Request {
    
    func valueForParamWith(id: String) -> String? {
        return self.parameters.get(id)
    }
    
    var requesParamString: String? {
        return valueForParamWith(id: DevTools.Strings.pathConventionId)
    }
    
    var requesParamUUID: UUID? {
        guard let requesParamString = requesParamString else { return nil }
        return UUID(requesParamString)
    }
    
    func log(_ app: Application) {
        DevTools.Logs.log(message: "\(self)", app: app)
    }
}
