// swift-tools-version:4.2

import Foundation
import PackageDescription

var dependencies: [Package.Dependency] = [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.16.0"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
        .package(url: "https://github.com/mxcl/Version.git", from: "1.0.0")
]

var finchDependencies: [Target.Dependency] = ["FinchCore", "Commandant", "Curry", "Version"]

#if swift(>=5.0)
dependencies.append(.package(url: "https://github.com/antitypical/Result.git", from:"4.1.0"))
finchDependencies.append("Result")
#endif
var targets: [Target] = [
    .target(
        name: "Finch",
        dependencies: ["FinchApp"]),
    .target(
        name: "FinchApp",
        dependencies: finchDependencies),
    .target(
        name: "FinchCore",
        dependencies: ["FinchUtilities"]),
    .target(
        name: "FinchUtilities",
        dependencies: ["Yams"])
]

if ProcessInfo.processInfo.environment["FINCH_TESTS"] != nil {
    targets.append(
        .testTarget(
            name: "FinchAppTests",
            dependencies: ["FinchApp", "SnapshotTesting", "Yams"],
            path: "Tests"
        )
    )
    dependencies.append(
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.1.0")
    )
}

let package = Package(
    name: "Finch",
    products: [
        .executable(name: "finch", targets: ["Finch"])
    ],
    dependencies: dependencies,
    targets: targets,
    swiftLanguageVersions: [.v4, .v4_2, .version("5")]
)
