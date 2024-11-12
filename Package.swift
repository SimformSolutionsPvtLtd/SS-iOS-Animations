//
//  Package.swift
//  SSSwiftUIAnimations
//
//  Created by Rahul Yadav on 11/11/24.
//

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SSSwiftUIAnimations",
    platforms: [
        .iOS(.v15) // Specify minimum platform versions
    ],
    products: [
        // Products define the executables and libraries a package produces and makes available to clients.
        .library(
            name: "SSSwiftUIAnimations",
            targets: ["SSSwiftUIAnimations"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SSSwiftUIAnimations",
            dependencies: [],
            path: "SSSwiftUIAnimations"
        )
    ]
)
