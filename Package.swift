// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SitemapGen",
  dependencies: [
     .package(url: "https://github.com/TommiKivimaki/Fichier.git", from: "0.3.0"),
  ],
  targets: [
    .target(
      name: "SitemapGen",
      dependencies: ["SitemapGenCore"]),
    .target(
      name: "SitemapGenCore",
      dependencies: ["Fichier"]),
    .testTarget(
      name: "SitemapGenTests",
      dependencies: ["SitemapGen", "Fichier"]),
  ]
)
