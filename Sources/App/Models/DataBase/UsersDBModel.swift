import Fluent
import Vapor

final class UsersDBModel: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "username")
    var username: String

    @Field(key: "password")
    var password: String
    
    @Field(key: "name")
    var name: String?
    
    init() { }

    init(username: String, password: String) {
        self.id = nil
        self.username = username
        self.password = password
    }
}

//
// RoutablePathProtocol
//

extension UsersDBModel: RoutablePathProtocol {
    static var initialPath: String { "users" }
}

//
// DataBaseSchemable
//

extension UsersDBModel: DataBaseSchemableProtocol {
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("name", .string, .required)
            .create()
    }
}

//
// DataBase utils
//

extension UsersDBModel {
    static func userWith(username: String, password: String, on database: Database) -> EventLoopFuture<UsersDBModel?> {
        let user = UsersDBModel(username: username, password: password)
        let allUsers = try! DatabaseUtils.CRUD.all(from: UsersDBModel.self, using: database)
        let storedUserMaybe = allUsers.map { $0.filter{ $0.username == user.username && $0.password == user.password }.first }
        return storedUserMaybe
    }
}
