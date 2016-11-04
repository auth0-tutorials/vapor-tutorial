import Vapor
import Fluent

let drop = Droplet()

drop.preparations.append(Contact.self)

drop.get("hello") { req in
    
    var contact = Contact(name: "Vapor")
    try contact.save()
    print(contact.id)
    
    return try JSON(node: contact)
}

drop.post("contacts", "create") { req in
    
    return try JSON(node: [
        "response": req.data["test"]?.string
        ])
}

drop.run()
