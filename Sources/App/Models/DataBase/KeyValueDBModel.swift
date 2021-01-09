import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

public final class KeyValueDBModel: Model, Content, Routable {
    
    public static let schema = "key_values"
    public static var initialPath: String { "config" }

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
