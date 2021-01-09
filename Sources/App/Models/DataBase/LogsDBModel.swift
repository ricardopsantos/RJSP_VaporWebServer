import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

public final class LogsDBModel: Model, Content, Routable {
    
    public static let schema = "app_messages"
    public static var initialPath: String { "messages" }

    @ID(key: .id)
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
