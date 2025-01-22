// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ZipZap",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v12),
		.macOS(.v10_13),
		.tvOS(.v12),
		.watchOS(.v4)
	],
	products: [
		.library(
			name: "ZipZap",
			targets: ["ZipZap"]),
	],
	targets: [
		.target(
			name: "ZipZap",
			path: "ZipZap",
			publicHeadersPath: "include",
			cSettings: [
				.headerSearchPath("Public/"),
				.headerSearchPath("./")
			],
			cxxSettings: [
				.define("CLANG_CXX_LIBRARY", to: "libc++"),
				.define("GCC_ENABLE_OBJC_EXCEPTIONS", to: "NO"),
				.define("OTHER_CPLUSPLUSFLAGS", to: "-fno-exceptions"),
			],
			linkerSettings: [
				.linkedLibrary("z")
			]),
		.testTarget(
			name: "ZipZapTests",
			dependencies: ["ZipZap"],
			path: "ZipZapTests"),
	],
	cxxLanguageStandard: .cxx11
)
