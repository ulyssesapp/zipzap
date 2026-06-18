// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ZipZap",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v17),
		.macOS(.v14),
		.tvOS(.v17),
		.watchOS(.v10)
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
				.headerSearchPath("include"),
				.headerSearchPath(".")
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
