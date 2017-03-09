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
    guard let name = request.data["name"]?.string else {
        let jsonResponse = try JSON(node: ["message": "Contacts must have a name"])
        return try Response(status: .badRequest, json: jsonResponse)
    }
    
    guard let email = request.data["email"]?.string else {
        let jsonResponse = try JSON(node: ["message": "Contacts must have an email"])
        return try Response(status: .badRequest, json: jsonResponse)
    }
    
    var contact = Contact(name: name, email: email)
    try contact.save()
    return contact
}

drop.get("contacts", "get") { request in
    let contacts = try Contact.query().all()
    let contactsNode = try contacts.makeNode()
    let nodeDictionary = ["contacts": contactsNode]
    return try JSON(node: nodeDictionary)
}

drop.run()
