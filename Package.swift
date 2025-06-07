// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FitJourneyApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "FitJourneyApp",
            targets: ["FitJourneyApp"])
    ],
    dependencies: [
        .package(path: "../SwiftUIApp")
    ],
    targets: [
        .executableTarget(
            name: "FitJourneyApp",
            dependencies: [
                .product(name: "Authentication", package: "SwiftUIApp"),
                .product(name: "FitnessTracker", package: "SwiftUIApp"),
                .product(name: "Networking", package: "SwiftUIApp")
            ],
            path: "Sources"),
        .testTarget(
            name: "FitJourneyAppTests",
            dependencies: ["FitJourneyApp"],
            path: "Tests")
    ]
)
