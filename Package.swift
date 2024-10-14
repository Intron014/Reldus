// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reldus",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "Reldus", targets: ["Reldus"]),
        .library(name: "ReldusCore", targets: ["ReldusCore"])
    ],
    dependencies: [
    //    .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
    //    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Reldus",
            dependencies: ["ReldusCore"]),
        .target(
            name: "ReldusCore"
        )
    ]
)
