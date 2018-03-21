// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CBGPromise",
    products: [
        .library(name: "CBGPromise", targets: ["CBGPromise"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "1.2.0")),
        .Package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(name: "CBGPromise", dependencies: [], path: "Sources"),
        .testTarget(name: "CBGPromiseTests", dependencies: ["CBGPromise", "Quick", "Nimble"]),
    ],
    swiftLanguageVersions: [4]
)
