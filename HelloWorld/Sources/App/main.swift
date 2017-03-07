import Vapor
import HTTP
import VaporMySQL
import MySQL

let drop = Droplet()
drop.preparations.append(Contact.self)
try drop.addProvider(VaporMySQL.Provider.self)

drop.get("hello") { request in
    return Response(status: .ok, headers: ["Content-Type": "text/plain"], body: "Hello, World!")
}

drop.get("version") { request in
    if let db = drop.database?.driver as? MySQLDriver {
        return try JSON(node: db.raw("SELECT version()"))
    }
    return "No db connection"
}

drop.post("contacts", "create") { request in
    guard let name = request.data["name"]?.string, let email = request.data["email"]?.string else {
        return try JSON(node: [
            "error": "1152",
            "message": "We had a problem creating a new contact"
            ])
    }
    var contact = Contact(name: name, email: email)
    try contact.save()
    return contact
}

drop.run()
