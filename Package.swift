// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ZipZap",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v18),
		.macOS(.v15),
		.tvOS(.v18),
		.watchOS(.v11)
	],
	products: [
		.library(
			name: "ZipZap",
			type: .dynamic,
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
			path: "ZipZapTests",
			resources: [
				.process("assets")
			],
			cSettings: [
				.headerSearchPath("../")
			])
	],
	cxxLanguageStandard: .cxx11
)
