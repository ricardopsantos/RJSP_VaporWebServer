import Fluent
import Vapor

final class TodoDBModel: Model, Content {
    static let schema = "todos"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

//
// RoutablePathProtocol
//

extension TodoDBModel: RoutablePathProtocol {
    static var initialPath: String { "todos" }
}

//
// DataBaseSchemable
//

extension TodoDBModel: DataBaseSchemableProtocol {
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .id()
            .field("title", .string, .required)
            .create()
    }
}
