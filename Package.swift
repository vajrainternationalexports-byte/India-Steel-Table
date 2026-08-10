// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ISSteelTablesPro",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ISSteelTablesPro",
            targets: ["ISSteelTablesPro"]
        ),
        .executable(
            name: "ISSteelTablesProCli",
            targets: ["ISSteelTablesProCli"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ISSteelTablesPro",
            dependencies: [],
            path: "Sources/ISSteelTablesPro",
            resources: [
                .process("Data/BundledData")
            ]
        ),
        .executableTarget(
            name: "ISSteelTablesProCli",
            dependencies: ["ISSteelTablesPro"],
            path: "Sources/ISSteelTablesProCli"
        ),
        .testTarget(
            name: "ISSteelTablesProTests",
            dependencies: ["ISSteelTablesPro"],
            path: "Tests/ISSteelTablesProTests"
        )
    ]
)
