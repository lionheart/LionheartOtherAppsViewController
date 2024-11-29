// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "LionheartOtherAppsViewController",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LionheartOtherAppsViewController",
            targets: ["LionheartOtherAppsViewController"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/lionheart/QuickTableView.git", from: "5.0.0"),
        .package(url: "https://github.com/lionheart/SuperLayout.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "LionheartOtherAppsViewController",
            dependencies: [
                .product(name: "QuickTableView", package: "QuickTableView"),
                .product(name: "SuperLayout", package: "SuperLayout")
            ],
            path: "LionheartOtherAppsViewController/Classes"
        ),
        .testTarget(
            name: "LionheartOtherAppsViewControllerTests",
            dependencies: ["LionheartOtherAppsViewController"]
        )
    ],
    swiftLanguageModes: [.v4]
)
