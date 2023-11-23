// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIServices",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "APIServices",
            targets: ["APIServices"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "APIServices",
            dependencies: ["Networking"]
        ),
        .testTarget(
            name: "APIServicesTests",
            dependencies: ["APIServices"],
            resources: [
                .copy("ResponseJSONs/Details1.json"),
                .copy("ResponseJSONs/LabelledDataResponse1.json")
            ]
        ),
    ]
)
