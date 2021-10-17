// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "JSONParser",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.watchOS(.v6),
		.tvOS(.v13)
	],
	products: [
		.library(
			name: "JSONParser",
			targets: [
				"JSONParser"
			]
		),
		.executable(
			name: "Tester",
			targets: [
				"Tester"
			]
		)
	],
	targets: [
		.target(
			name: "JSONParser"
		),
		.target(
			name: "Tester",
			dependencies: [
				"JSONParser"
			]
		)
	]
)
