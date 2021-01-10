import Vapor
//
import Fluent
import FluentPostgresDriver

public final class LogsDBModel: Model, Content {
    
    public static let schema = "app_messages_v2"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: Fields.message.fieldKey)
    var message: String

    @Field(key: Fields.sender.fieldKey)
    var messageSender: String

    @Field(key: Fields.messageType.fieldKey)
    var messageType: String
    
    @Field(key: Fields.signature.fieldKey)
    var signature: String
    
    @Field(key: Fields.recordDate.fieldKey)
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

extension LogsDBModel: RoutableCRUDPath {
    public static var crudPath: String { "messages" }
}

//
// DataBaseSchemable
//

extension LogsDBModel: DataBaseSchemableProtocol {
    
    enum Fields: String {
        case message
        case sender
        case messageType = "message_type"
        case signature
        case recordDate = "record_date"

        var fieldKey: FieldKey { return self.rawValue.fieldKey }
    }
    
    static func createTable(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Self.schema)
            .ignoreExisting() // Ignore if table exists
            .id()
            .field(Fields.message.fieldKey, .string, .required)
            .field(Fields.sender.fieldKey, .string, .required)
            .field(Fields.messageType.fieldKey, .string, .required)
            .field(Fields.signature.fieldKey, .string, .required)
            .field(Fields.recordDate.fieldKey, .datetime, .required)
            .create()
    }
}
