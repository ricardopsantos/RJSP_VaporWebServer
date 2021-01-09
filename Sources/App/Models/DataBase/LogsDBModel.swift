import Vapor

import Fluent
import FluentPostgresDriver
import FluentMySQLDriver

public final class LogsDBModel: Model, Content {
    
    public static let schema = "app_messages_v2"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "message")
    var message: String

    @Field(key: "sender")
    var messageSender: String

    @Field(key: "message_type")
    var messageType: String
    
    @Field(key: "signature")
    var signature: String
    
    @Field(key: "record_date")
    var recordDate: Date
    
    public init() {
        self.id = nil
         self.message = ""
        self.messageSender = ""
        self.messageType = ""
        self.signature = ""
        self.recordDate = Date()
    }
}

//
// RoutablePathProtocol
//

extension LogsDBModel: RoutablePathProtocol {
    public static var initialPath: String { "messages" }
}

//
// DataBaseSchemable
//

extension LogsDBModel: DataBaseSchemable {
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .id()
            .field("message", .string, .required)
            .field("sender", .string, .required)
            .field("message_type", .string, .required)
            .field("signature", .string, .required)
            .field("record_date", .datetime, .required)
            .create()
    }
}
