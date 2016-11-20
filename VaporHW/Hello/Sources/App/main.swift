import Vapor
import Fluent
import VaporMySQL

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(Post.self)

drop.post { req in
    
//    return try JSON(node: Post.all().makeNode())
    print(req.json)
    var post = try Post(node: req.json)
    try post.save()
    return post
}

drop.get("version") { req in
    if let db = drop.database?.driver as? MySQLDriver {
        return try JSON(node: try db.raw("SELECT version()"))
    } else {
        return "fudeu!"
    }
    
}

drop.resource("posts", PostController())

drop.run()
