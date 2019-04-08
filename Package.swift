// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CBGPromise",
    products: [
        .library(
            name: "CBGPromise",
            targets: ["CBGPromise"]
        ),
    ],
    targets: [
        .target(
            name: "CBGPromise",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "CBGPromiseTests",
            dependencies: ["CBGPromise"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [5]
)
