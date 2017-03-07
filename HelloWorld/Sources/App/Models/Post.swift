import Vapor
import Fluent
import Foundation

final class Contact: Model {
    var id: Node?
    var name: String
    var email: String
    var exists: Bool = false
    
    init(name: String, email: String) {
        self.id = UUID().uuidString.makeNode()
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
        try database.create("contact") { contacts in
            contacts.id()
            contacts.string("name")
            contacts.string("email")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("contact")
    }
}
