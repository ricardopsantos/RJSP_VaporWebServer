import Fluent
import Vapor

final class UsersDBModel: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: Fields.username.fieldKey)
    var username: String

    @Field(key: Fields.password.fieldKey)
    var password: String
    
    @Field(key: Fields.name.fieldKey)
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

extension UsersDBModel: RoutableCRUDPath {
    static var crudPath: String { "users" }
}

//
// DataBaseSchemable
//

extension UsersDBModel: DataBaseSchemableProtocol {
    
    enum Fields: String {
        case username
        case password
        case name

        var fieldKey: FieldKey { return self.rawValue.fieldKey }
    }
    
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .ignoreExisting() // Ignore if table exists
            .id()
            .field(Fields.username.fieldKey, .string, .required)
            .field(Fields.password.fieldKey, .string, .required)
            .field(Fields.name.fieldKey, .string, .required)
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
