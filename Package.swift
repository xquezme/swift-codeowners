// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-codeowners",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/davbeck/swift-glob.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(name: "swift-codeowners", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "Glob", package: "swift-glob")
        ]),
        .testTarget(
            name: "swift-codeowners-unit-tests",
            dependencies: ["swift-codeowners"]
        ),
    ]
)
