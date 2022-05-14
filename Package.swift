// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "laurentboileau.github.io",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "laurentboileau.github.io",
            targets: ["laurentboileau.github.io"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .executableTarget(
            name: "laurentboileau.github.io",
            dependencies: ["Publish"]
        )
    ]
)
