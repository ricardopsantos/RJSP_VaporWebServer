import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) throws {

    app.routes.caseInsensitive = true
    
    switch app.environment {
    case .production: app.http.server.configuration.port = 8080
    case .development: app.http.server.configuration.port = 5678
    case .testing: app.http.server.configuration.port = 5678
    case .staging: app.http.server.configuration.port = 5678
    default: _ = 1
    }
  
    DatabaseManager.setup(app: app)
        
    try routes(app)
    
    LogsManager.log(message: "Routes : \(app.routes.all)", app: app)

}
