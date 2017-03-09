import Vapor
import Fluent

final class Contact: Model {
    var id: Node?
    var name: String
    var email: String
    var exists: Bool = false
    static var entity = "contacts"
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        email = try node.extract("email")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "email": email
        ])
    }
    
}

extension Contact: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create("contacts") { contacts in
            contacts.id()
            contacts.string("name")
            contacts.string("email")
        }
    }
    
    static func revert(_ database: Database) throws {
    }
}
