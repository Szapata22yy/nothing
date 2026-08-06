// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HorasSamuel",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .executable(name: "HorasSamuelApp", targets: ["HorasSamuelApp"])
    ],
    targets: [
        .executableTarget(
            name: "HorasSamuelApp",
            path: "Sources/HorasSamuelApp"
        )
    ]
)
