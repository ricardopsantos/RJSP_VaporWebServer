import Vapor
//
import Fluent
import FluentPostgresDriver

public final class KeyValueDBModel: Model, Content {
    
    public static let schema = "key_values"

    @ID(custom: Fields.key.fieldKey)
    public var id: String?

    @Field(key: Fields.key.fieldKey)
    var key: String

    @Field(key: Fields.value.fieldKey)
    var value: String

    @Field(key: Fields.encoding.fieldKey)
    var encoding: String
    
    public init() {
        self.encoding = ""
        self.key = ""
        self.value = ""
    }
    
    public init(key: String = "", encoding: String = "", value: String = "") {
        self.encoding = encoding
        self.key = key
        self.value = value
    }
}

//
// RoutablePathProtocol
//

extension KeyValueDBModel: RoutableCRUDPath {
    public static var crudPath: String { "config" }
}

//
// DataBaseSchemable
//

extension KeyValueDBModel: DataBaseSchemableProtocol {
    
    enum Fields: String {
        case key
        case value
        case encoding

        var fieldKey: FieldKey { return self.rawValue.fieldKey }
    }
    
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .ignoreExisting() // Ignore if table exists
            .id()
            .field(Fields.key.fieldKey, .string, .required)
            .field(Fields.value.fieldKey, .string, .required)
            .field(Fields.encoding.fieldKey, .string, .required)
            .create()
    }
}
