// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Transaction",
    products: [
        .library(name: "Transaction", targets: ["Transaction"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.5"),
    ],
    targets: [
        .target(name: "Transaction", dependencies: ["Vapor"]),
        .testTarget(name: "TransactionTests", dependencies: ["Transaction", "Vapor"]),
    ]
)
