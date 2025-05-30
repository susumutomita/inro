// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Inro",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "InroCore", targets: ["InroCore"]),
        .library(name: "InroUI", targets: ["InroUI"]),
        .library(name: "InroApp", targets: ["InroApp"])
    ],
    targets: [
        // Core business logic
        .target(
            name: "InroCore",
            path: "InroCore/Sources",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        
        // UI components and design system
        .target(
            name: "InroUI",
            dependencies: ["InroCore"],
            path: "InroUI/Sources",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Main app target
        .target(
            name: "InroApp",
            dependencies: ["InroCore", "InroUI"],
            path: "InroApp/Sources",
            resources: [
                .process("Resources")
            ]
        ),
        
        // Tests
        .testTarget(
            name: "InroCoreTests",
            dependencies: ["InroCore"],
            path: "InroCore/Tests"
        )
    ]
)