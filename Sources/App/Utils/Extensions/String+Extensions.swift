 //
//  Created by Ricardo Santos on 10/01/2021.
//

import Foundation
import Fluent

public extension String {
    
    var fieldKey: FieldKey { return FieldKey(stringLiteral: self) }
    
    var environmentValue: String? { return ConfigManager.valueWith(key: self) }

}
