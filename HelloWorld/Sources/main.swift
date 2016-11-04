import Vapor
import Fluent

let drop = Droplet()

drop.get("hello") { req in
    return try JSON(node: [
        "valid": true
        ])
}

drop.post("contacts", "create") { req in
    
    return try JSON(node: [
        "response": req.data["test"]?.string
        ])
}

drop.run()
