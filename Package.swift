// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IronOxide",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
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
