import PackageDescription

let package = Package(
    name: "HelloWorld",
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 1, minor: 1)
    ]
)
