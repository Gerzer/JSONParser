// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "JSONParser",
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
