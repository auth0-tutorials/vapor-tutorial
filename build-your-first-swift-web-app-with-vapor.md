---
layout: post
title: "Server Side Swift App with Vapor and Droplet"
description: ""
date: 2016-11-05 8:30
alias: /2017/03/05/server-side-swift-app-with-vapor-and-droplet/
author:
  name: Rafael Sacchi
  url: https://twitter.com/rafael_sacchi
  mail: rafaelmsacchi@gmail.com
  avatar: http://www.gravatar.com/avatar/b7e1e53144c06ecfdef91f0e4229a08a
design:
  bg_color: "#2d5487"
  image: https://cdn.auth0.com/blog/customer-data/customer-data-icon.png
tags:
- vapor
- swift
- server-side
- backend
- rest
---

---

**TL;DR**: The Swift language is growing in popularity not only for iOS apps, but also for server-side applications. In this article, we'll use Vapor and Droplet to build a web app.

---

> Note: This tutorial was written using Vapor 1.5

Since it was introduced in mid-2014, Swift language has seen [stunning growth in popularity](http://redmonk.com/sogrady/2016/07/20/language-rankings-6-16/). When the language became [open source](https://developer.apple.com/swift/blog/?id=34) and available on Linux in late-2015, server-side applications started to gain popularity as well.

People involved with [IBM Kitura](https://github.com/IBM-Swift/Kitura), [Vapor](https://github.com/vapor/vapor), [Zewo](https://github.com/Zewo/Zewo) and [Perfect](https://github.com/PerfectlySoft/Perfect) - the hottest Swift server-side frameworks - were invited by Apple to focus on server-side needs like networking, security and HTTP/WebSocket parsing. This way, they will work to make possible to write pure Swift server-side frameworks, without needing to rely on C libraries.

In this tutorial, we'll learn how to set up Vapor framework, learn its essential concepts, and build a simple web application for creating and retrieving contacts.

## Swift Server Side Prerequisites

You need a machine running Mac OS X 10.11+ or Linux. Apple builds and tests binaries for Ubuntu 14.04 and 16.04 and 16.10, but it's possible to build the language from source in other Linux distributions. You can download the binaries [here](https://swift.org/download/).

## Setting up Swift and Vapor

First of all, we need to [download and install Swift 3](https://swift.org/download/) (the steps are different for Ubuntu and macOS). After that, it's necessary to install the [Vapor Toolbox](https://github.com/vapor/toolbox), a command line interface for common Vapor tasks, as `build` and `serve`. Run the following script to install the Toolbox.

```
curl -sL toolbox.vapor.sh | bash
```

To verify if the installation was successful, run `vapor --help`, which should show a list of commands. To update the toolbox, just run `vapor self update`.

To make sure everything is running fine, let's build a Hello World app.

### Hello World App

First of all, let's create the new Vapor project.

```
vapor new HelloWorld
```

Vapor will generate a folder structure with some files. Vapor command line interface uses [Swift Package Manager](https://swift.org/package-manager/) to manage the dependencies.

If you are using macOS and want to edit the project on Xcode, run `vapor xcode -y` in the HelloWorld subdirectory to generate and open an Xcode project.

Look for the `main.swift` file and place the following code there.

```swift
import Vapor

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("posts", PostController())

drop.run()

```

> Note: starting on version 1.1, Vapor already generates this code when you create a new project. But it's here just in case things change, considering that Vapor is in such a fast development pace.

After that, run the two following commands.

```
vapor build
vapor run serve
```

And it should be done. Now vapor is serving its HelloWorld page on localhost:8080. To check that things are working out, just open your browser and type `http://localhost:8080`.


## Bulding a Contacts App

Now that we have our server-side Swift environment setup working with Vapor, we are going to start creating our Contacts App. This application will have two features: add a new contact and retrieve all contacts. But first of all, let's check out how Droplet works.

### Playing with Droplet

[Droplet](https://vapor.github.io/documentation/guide/droplet.html) is a container that makes it easy to use many of Vapor's features. It's responsible for starting and running the server, set up environments, register routes, and more. It's necessary to import Vapor to initialize and run a droplet.

```swift
import Vapor
import HTTP

let drop = Droplet()

// config, registering routes, etc

drop.run()
```

Let's now register a get request at localhost:8080/hello.

```swift
drop.get("hello") { request in
    return "Hello World!"
}
```

The first parameter is the endpoint, and the closure returns a response to the request. The returned value must be of a type who conforms to the `ResponseRepresentable` protocol. Strings and JSON already conform to this protocol, but it's also possible to create a [custom response](https://vapor.github.io/documentation/http/response-representable.html).

```swift
drop.get("hello") { request in
	return Response(status: .ok, headers: ["Content-Type": "text/plain"], body: "Hello, World!")
}
```

It's also pretty straightforward to create an endpoint that responds to POST requests and returns data in JSON format.

```swift
drop.post("contacts", "create") { request in
    return try JSON(node: [
        "response": request.data["name"]?.string
        ])
}
```

This register a HTTP endpoint at `http://localhost:8080/contacts/create` that responds to POST requests and returns a response with data in JSON format. It gets the data sent as JSON in the request for the key `test` and retrieves its string value on `request.data["test"]?.string`.

To test this endpoint we can use a program like [Postman](https://www.getpostman.com/) or cURL:

```
curl -i -H "Content-Type: application/json" -X POST -d '{"name": "John"}' "localhost:8080/contacts/create"
```


Don't forget to run `vapor build` and `vapor run serve` before testing it.


### MySQL installation

Let's make the database integration with [MySQL](https://www.mysql.com/). First of all, it's necessary to install MySQL and start it.

On Linux:

```sh
sudo apt-get update
sudo apt-get install -y mysql-server libmysqlclient-dev
sudo mysql_install_db
sudo service mysql start
```

On macOS:

```sh
brew install mysql
brew link mysql
mysql.server start
```
> In case you don't have Homebrew installed, follow the instructions at [Homebrew's homepage](http://brew.sh/)

### Fluent

[Fluent](https://github.com/vapor/fluent) is a Swift ORM framework also made by Vapor. It has drivers for a [good range of databases](https://github.com/search?q=org%3Avapor+driver) and is totally independent from vapor framework.

To connect your model objects to a database, it's also necessary to install a database provider, which is a way to add third party packages to a project. The relationship between database, fluent, drivers and providers is illustrated in the following image:

<img src="fluent-chart.png">

### Database configuration and integration

It's necessary to add Fluent and MySQL provider to your project. Open the `Package.swift` file and add these two dependencies:

```
.Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor: 0),
.Package(url: "https://github.com/vapor/fluent.git", majorVersion: 1, minor: 4)
```

Run `vapor build` to install them. After that, you'll need to manually [create a database on MySQL](https://dev.mysql.com/doc/refman/5.7/en/creating-database.html) named `vapor`. Then create two config files for database access in the project. In the  `/config` subdirectory, create a new file named `mysql.json` and update it with this content:

```json
{
  "host": "127.0.0.1",
  "user": <your-user-name>,
  "password": <your-password>,
  "database": "vapor",
  "port": "3306",
  "encoding": "utf8"
}
```
> Note: Replace `your-user-name` and `your-password` with the username and passwords that you defined when creating the database.

Still in the `/config` subdirectory, create a new subdirectory named `/secrets`. Copy and paste the `mysql.json` file above in the secrets subdirectory.

Now it's time to add the MySQL provider to the Droplet. In the `main.swift` file, right after creating the droplet, add this line:

```swift
try drop.addProvider(VaporMySQL.Provider.self)
```

To check that everything is working fine, let's add an endpoint that returns the currently installed MySQL version. Add this to `main.swift` file:

```swift
drop.get("version") { request in
    if let db = drop.database?.driver as? MySQLDriver {
        return try JSON(node: db.raw("SELECT version()"))
    }
    return "No db connection"
}
```

To test it, just run 

```
curl -i -H "Accept: application/json" "localhost:8080/version"
```

It should return a response in the following format:

```json
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Date: Thu, 09 Mar 2017 02:15:18 GMT
Content-Length: 24

[{"version()":"5.x.y"}]
```

### Creating your model

To create a model in Vapor, you need first to create a file named `Models/Contact.swift` in the `App` group of the Xcode project. Then import these two modules and create the model with its properties:

```swift
import Vapor
import Fluent

final class Contact: Model {
	var name: String
	var email: String
	var exists: Bool = false
	static var entity = "contacts"
}
```

It's also necessary to conform to `Model` protocol. This means implementing a few methods and properties: the node initializer and node representable methods, and the id property.

The node initializer is responsible for creating the model from the persisted data. Add it to the `Contact` class:

```swift
init(node: Node, in context: Context) throws {
	id = try node.extract("id")
	name = try node.extract("name")
	email = try node.extract("email")
}
```

On the other hand, the node representable method is responsible for preparing the data to be saved in the database:

```swift
func makeNode(context: Context) throws -> Node {
	return try Node(node: [
		"id": id,
		"name": name,
		"email": email
	])
}
```

Finally, the it's necessary to add an identifier to the model. Just add this single line as another `Contact` property:

```swift
var id: Node?
```

### Model preparations

Some databases need to be prepared for new schemas. In Fluent, it's necessary to implement the `Preparation` protocol to prepare the database for any task it may need to perform in runtime. Add this extension to the `Contact` class:

```swift
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
```

The `prepare(_:)` function is responsible for creating the `contacts` table in the database. If anything goes wrong, the `revert(_:)` function is called. We'll keep the `revert(_:)` function empty for this tutorial.

It's necessary to add a preparation for the `Contact` model in the droplet. Add this in the `main.swift` file:

```swift
drop.preparations.append(Contact.self)
```

Then you're ready to save and retrieve your models from the database.

### Creating and retrieving contacts

To check that everything works, let's add two endpoints: one for creating a new contact and the other one for retrieving all contacts in database.

## Aside: Auth0 integration and JWT

https://github.com/kylef/JSONWebToken.swift

## Conclusion and next steps