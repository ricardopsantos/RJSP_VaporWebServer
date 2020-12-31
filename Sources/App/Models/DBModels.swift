import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

public final class DBLogs: Model, Content {
    
    public static let schema = "app_messages"

    @ID(custom: "id")
    public var id: String?

    @Field(key: "message")
    var message: String

    @Field(key: "messagesender")
    var messageSender: String

    @Field(key: "message_type")
    var messageType: String
    
    @Field(key: "signature")
    var signature: String
    
    @Field(key: "record_date")
    var recordDate: Date
    
    public init() {
        self.id = ""
        self.message = ""
        self.messageSender = ""
        self.messageType = ""
        self.signature = ""
        self.recordDate = Date()
    }
}

public final class DBKeyValue: Model, Content {
    
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
