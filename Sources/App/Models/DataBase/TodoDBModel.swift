import Fluent
import Vapor

final class TodoDBModel: Model, Content, Routable {
    static let schema = "todos"
    static var initialPath: String { "todos" }

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

