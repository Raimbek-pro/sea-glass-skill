// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SeaGlass",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SeaGlass",
            targets: ["SeaGlass"]
        ),
    ],
    targets: [
        .target(
            name: "SeaGlass",
            path: "SeaGlass/Sources"
        ),
    ]
)
