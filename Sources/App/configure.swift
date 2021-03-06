import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {

    app.routes.caseInsensitive = true
    app.routes.defaultMaxBodySize = "500kb"  // Increases the streaming body collection limit to 500kb
    
    switch app.environment {
    case .production: app.http.server.configuration.port = 8080
    case .development: app.http.server.configuration.port = 5678
    case .testing: app.http.server.configuration.port = 5678
    case .staging: app.http.server.configuration.port = 5678
    default: _ = 1
    }
  
    try? DatabaseManager.setup(app: app)
        
    DBMigration.setup(on: app.db)
    app.migrations.add(DBMigration())
    
    try routes(app)
    
    DevTools.Logs.log(message: "Routes : \(app.routes.all)", app: app)
    
}
