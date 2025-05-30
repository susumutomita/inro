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
        .iOSApplication(
            name: "Inro",
            targets: ["InroApp"],
            bundleIdentifier: "com.inro.age-verification",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .person),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [.pad, .phone],
            supportedInterfaceOrientations: [.portrait]
        )
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
        .executableTarget(
            name: "InroApp",
            dependencies: ["InroCore", "InroUI"],
            path: "InroApp/Sources"
        ),
        
        // Tests
        .testTarget(
            name: "InroCoreTests",
            dependencies: ["InroCore"],
            path: "InroCore/Tests"
        )
    ]
)