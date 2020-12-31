import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
LogsManager.log(message: "App started", app: app)
try configure(app)
try app.run()
defer {
    LogsManager.log(message:"App will shut down", app: app)
    DatabaseManager.shutdownGracefully(app)
    try? app.eventLoopGroup.syncShutdownGracefully()
    app.shutdown()
}
