// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Swift-Common",
    products: [
        .library(name: "SourceParsingFramework", targets: ["SourceParsingFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.20.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        .package(url: "https://github.com/uber/swift-concurrency.git", .upToNextMajor(from: "0.6.5")),
    ],
    targets: [
        .target(
            name: "SourceParsingFramework",
            dependencies: [
                "Utility",
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
                "Utility",
                "SourceParsingFramework",
            ]),
    ],
    swiftLanguageVersions: [4]
)
