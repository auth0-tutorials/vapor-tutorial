import Vapor
import VaporMySQL
import Fluent

//let drop = Droplet()
//drop.providers = [VaporMySQL.Provider.self]
let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(Contact.self)

drop.get("hello") { req in
    
    var contact = Contact(name: "Vapor")
    try contact.save()
    print(contact.id as Any)
    
    return try JSON(node: contact)
}

drop.post("contacts", "create") { req in
    
    return try JSON(node: [
        "response": req.data["test"]?.string
        ])
}

drop.run()
