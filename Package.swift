// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HorasSamuel",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .executable(name: "HorasSamuel", targets: ["HorasSamuel"])
    ],
    targets: [
        .executableTarget(
            name: "HorasSamuel",
            path: ".",
            exclude: ["Package.swift"]
        )
    ]
)
