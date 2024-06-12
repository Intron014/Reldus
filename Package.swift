// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reldus",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "Reldus", targets: ["Reldus"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Reldus")
        // .testTarget(
        //     name: "ReldusTests",
        //     dependencies: [
        //         "Reldus",
        //         .product(name: "Testing", package: "swift-testing"),
        //     ]
        // ),
    ]
)
