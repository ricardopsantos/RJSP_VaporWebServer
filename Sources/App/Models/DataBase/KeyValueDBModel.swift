import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

public final class KeyValueDBModel: Model, Content {
    
    public static let schema = "key_values"

    @ID(custom: "key")
    public var id: String?

    @Field(key: "key")
    var key: String

    @Field(key: "value")
    var value: String

    @Field(key: "encoding")
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

extension KeyValueDBModel: RoutablePathProtocol {
    public static var initialPath: String { "config" }
}

//
// DataBaseSchemable
//

extension KeyValueDBModel: DataBaseSchemable {
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .id()
            .field("key", .string, .required)
            .field("value", .string, .required)
            .field("encoding", .string, .required)
            .create()
    }
}
