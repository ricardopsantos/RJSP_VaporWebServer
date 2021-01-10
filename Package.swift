// swift-tools-version:5.2
import PackageDescription


let appName = "App"

let swiftSettings: SwiftSetting = .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
let serverTargetDependency: Target.Dependency = .product(name: "Vapor", package: "vapor")

//
// ####### Dependencies insit
//
let fluentDependency: Target.Dependency = .product(name: "Fluent", package: "fluent")
let postgresDependency: Target.Dependency = .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
let mysqlDependency: Target.Dependency = .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver")
//let rjsLibUFBaseDependency: Target.Dependency = .product(name: "RJSLibUFBase", package: "rjps-lib-uf")
//let rjsLibUFStorageDependency: Target.Dependency = .product(name: "RJSLibUFStorage", package: "rjps-lib-uf")

//
// ####### Dependencies end
//

let dependencies = [serverTargetDependency,
                    fluentDependency, postgresDependency, mysqlDependency
//                    ,rjsLibUFBaseDependency
]

let package = Package(
    name: appName,
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.36.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0")
        //,.package(name: "rjps-lib-uf", url: "https://github.com/ricardopsantos/RJSLibUF", from: "1.0.1")
    ],
    targets: [
        .target(name: appName, dependencies: dependencies, swiftSettings: [swiftSettings]),
        .target(name: "Run", dependencies: [.target(name: appName)]),
        .testTarget(name: "AppTests", dependencies: [.target(name: "App"), .product(name: "XCTVapor", package: "vapor"),])
    ]
)
