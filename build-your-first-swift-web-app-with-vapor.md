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


### Database integration

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

### MySQL Driver and Provider

- updating dependecies
- create database manually
- folder secrets and mysql.json
- provider code
- droplet with preparations
- model code
- endpoint code

### Creating and retrieving contacts

## Aside: Auth0 integration and JWT

https://github.com/kylef/JSONWebToken.swift

## Conclusion and next steps