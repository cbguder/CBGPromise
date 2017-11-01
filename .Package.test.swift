import PackageDescription

let package = Package(
    name: "CBGPromise",
    dependencies: [
        .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 7)
    ]
)
