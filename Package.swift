// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Inro",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "InroCore",
            targets: ["InroCore"]),
        .executable(
            name: "InroApp",
            targets: ["InroApp"])
    ],
    targets: [
        .target(
            name: "InroCore",
            dependencies: []),
        .executableTarget(
            name: "InroApp",
            dependencies: ["InroCore"]),
        .testTarget(
            name: "InroCoreTests",
            dependencies: ["InroCore"])
    ]
)