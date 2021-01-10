import Fluent
import Vapor

final class TodoDBModel: Model, Content {
    static let schema = "todos"

    @ID(key: .id)
    var id: UUID?

    @Field(key: Fields.title.fieldKey)
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

extension TodoDBModel: RoutableCRUDPath {
    static var crudPath: String { "todos" }
}

//
// DataBaseSchemable
//

extension TodoDBModel: DataBaseSchemableProtocol {
    
    enum Fields: String {
        case title

        var fieldKey: FieldKey { return self.rawValue.fieldKey }
    }
    
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .ignoreExisting() // Ignore if table exists
            .id()
            .field(Fields.title.fieldKey, .string, .required)
            .create()
    }
}
