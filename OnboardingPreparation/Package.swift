// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "myProject",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "myProject",
            targets: ["myProject"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(path: "../../story-ios-sdk")
    ],
    targets: [
        .executableTarget(name: "myProject",dependencies: [
            .product(name: "StorySDK",
            package: "story-ios-sdk",
            condition: .when(platforms: [.macOS])),
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ])
    ]
)
