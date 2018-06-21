// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Transaction",
    products: [
        .library(name: "Transaction", targets: ["Transaction"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Transaction", dependencies: []),
        .testTarget(name: "TransactionTests", dependencies: ["Transaction"]),
    ]
)
