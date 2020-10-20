// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "JSONParser",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.library(
			name: "JSONParser",
			targets: [
				"JSONParser"
			]
		)
	],
	targets: [
		.target(
			name: "JSONParser"
		)
	]
)
