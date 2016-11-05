---
layout: post
title: "Build Your First Swift Web App with Vapor"
description: ""
date: 2016-11-05 8:30
alias: /2016/11/05/build-your-first-swift-web-app-with-vapor/
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

**TL;DR**: The Swift language is growing popularity not only for iOS apps, but also for server-side applications. In this article, we'll use Vapor framework to build a web app.

---

Since it was introduced in mid-2014, Swift language has seen [stunning growth in popularity](http://redmonk.com/sogrady/2016/07/20/language-rankings-6-16/). When the language became [open source](https://developer.apple.com/swift/blog/?id=34) and available on linux in late-2015, server-side applications started to gain popularity as well.

Recently, Apple announced the creation of [Swift Server APIs working group](https://swift.org/blog/server-api-workgroup/). They invite participants in the community to provide new Swift APIs focused on server-side needs (as networking, security and HTTP/WebSocket parsing). This way, it will be possible to write pure Swift server-side frameworks, without needing to rely on C libraries. 

The work group steering team and stakeholders consists of people involved in the hottest Swift server-side frameworks at the moment: [IBM Kitura](https://github.com/IBM-Swift/Kitura), [Vapor](https://github.com/vapor/vapor), [Zewo](https://github.com/Zewo/Zewo) and [Perfect](https://github.com/PerfectlySoft/Perfect).

In this tutorial, we'll learn how to set up Vapor framework, learn its essential concepts, and build a simple web application for creating and retrieving contacts.

## Prerequisites

You need a machine [able to run Swift 3](https://swift.org/download/).

## Environment setup

First of all, we need to [download and install Swift 3](https://swift.org/download/).

## Example