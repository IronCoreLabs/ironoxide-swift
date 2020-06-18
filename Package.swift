// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "IronOxide",
    products: [
        .library(
            name: "IronOxide",
            targets: ["IronOxide"]
        ),
    ],
    dependencies: [
        .package(name: "SwiftJWT", url: "https://github.com/IBM-Swift/Swift-JWT.git", from: "3.6.1"),
    ],
    targets: [
        .systemLibrary(
            name: "libironoxide",
            pkgConfig: "ironoxide",
            providers: [
                .brew(["libironoxide"]),
            ]
        ),
        .target(
            name: "IronOxide",
            dependencies: ["libironoxide"]
        ),
        .testTarget(
            name: "IronOxideTests",
            dependencies: ["IronOxide", "SwiftJWT"]
        ),
    ]
)
