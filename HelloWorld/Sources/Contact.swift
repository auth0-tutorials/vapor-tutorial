import Vapor
import Fluent

final class Contact: Model {
    var id: Node?
    var name: String

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }

    init(name: String) {
        self.name = name
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create("contact") { contact in
            contact.id()
            contact.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("contact")
    }
    
}
