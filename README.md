<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat" alt="Swift 5.3">
   </a>
    <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Xcode-12.0.1-blue.svg" alt="Swift 5.3">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
   <a href="https://twitter.com/ricardo_psantos/">
      <img src="https://img.shields.io/badge/Twitter-@ricardo_psantos-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

## About

This is quick start web server, built using [Vapor 4.0](https://vapor.codes/) and was how [this series of articles](https://ricardojpsantos.medium.com/deploying-a-vapor-swift-web-app-into-heroku-cloud-platform-part-1-2-69de939ce4d8) started...

---

## Features

Using [Swift generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html), the routing funtion...

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

...will automatically build all this routes with the basic CRUD operations.

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
