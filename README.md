## About

This is quick start web server built using [Vapor](https://vapor.codes/) and is how [this](https://ricardojpsantos.medium.com/deploying-a-vapor-swift-web-app-into-heroku-cloud-platform-part-1-2-69de939ce4d8) started...

---

## Features

Using [Swift generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html) this routing funtion...

```swift
func routes(_ app: Application) throws {
    
    app.get { req -> String in
        req.log(app)
        return "Hello stranger!\n\nChoose wishly:\n* https://www.linkedin.com/in/ricardopsantos\n* https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    }
    
    app.get("version") { req -> String in
        req.log(app)
        let version = "Version 1.0.0"
        return "\(version)\n\n\(app.environment)"
    }
       
    let collection_Config = GenericController<KeyValueDBModel>()
    collection_Config.validOperations = [.get]
    try app.register(collection: collection_Config)

    let collection_Logs = GenericController<LogsDBModel>()
    collection_Logs.validOperations = [.add, .get]
    try app.register(collection: collection_Logs)

    let collection_Todo = GenericController<TodoDBModel>()
    collection_Todo.validOperations = [.all]
    try app.register(collection: collection_Todo)
}
```
can handles all this routes

* `GET` 
* `GET /version`

* `GET /config`
* `GET /config/operations/:id`

* `GET /messages`
* `POST /messages`
* `GET /messages/operations/:id`
* `DELETE /messages/operations/:id`

* `GET /todos`
* `POST /todos`
* `GET /todos/operations/:id`
* `DELETE /todos/operations/:id`
