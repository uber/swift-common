// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Swift-Common",
    products: [
        .library(name: "SourceParsingFramework", targets: ["SourceParsingFramework"]),
        .library(name: "CommandFramework", targets: ["CommandFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.23.1"),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .upToNextMajor(from: "0.0.1")),
        .package(url: "https://github.com/uber/swift-concurrency.git", .upToNextMajor(from: "0.6.5")),
    ],
    targets: [
        .target(
            name: "SourceParsingFramework",
            dependencies: [
                "SwiftToolsSupport",
                "Concurrency",
                "SourceKittenFramework",
            ]),
        .testTarget(
            name: "SourceParsingFrameworkTests",
            dependencies: ["SourceParsingFramework"],
            exclude: [
                "Fixtures",
            ]),
        .target(
            name: "CommandFramework",
            dependencies: [
                "SwiftToolsSupport",
                "SourceParsingFramework",
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
