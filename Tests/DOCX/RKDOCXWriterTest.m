//
//  RKDOCXWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 25.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXWriterTest.h"

@implementation RKDOCXWriterTest

- (void)testGeneratingEmptyDOCXDocument
{
	//RKDocument *document = [[RKDocument alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString: @""]];
	NSData *converted = [@"1234" dataUsingEncoding: NSUTF8StringEncoding];
	
	[self assertDOCX:converted withTestDocument:@"empty"];
}

- (void)assertDOCX:(NSData *)docx withTestDocument:(NSString *)name
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:@"docx" subdirectory:@"Test Data/docx"];
	
	XCTAssertNotNil(url, @"Cannot build URL");
	
	NSError *error;
	NSData *testContent = [NSData dataWithContentsOfURL:url options:0 error:&error];
	XCTAssertNotNil(testContent, @"Load failed with error: %@", error);
	
	NSLog(@"Testing with file %@", name);
	
	return [self assertGeneratedDOCXData:docx withExpectedData:testContent filename:name];
}

- (void)assertGeneratedDOCXData:(NSData *)generated withExpectedData:(NSData *)expected filename:(NSString *)filename
{
	XCTAssertTrue([generated isEqualToData: expected], @"Unexpected DOCX conversion.");
	if (![generated isEqualToData: expected]) {
		NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath: NSTemporaryDirectory()];
		temporaryDirectoryURL = [temporaryDirectoryURL URLByAppendingPathComponent: @"rtfkit-docx-test-verification"];
		
		[NSFileManager.defaultManager createDirectoryAtURL:temporaryDirectoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
		
		[generated writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: filename] URLByAppendingPathExtension: @"docx"] atomically:YES];
		[expected writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: [filename stringByAppendingString: @"-expected"]] URLByAppendingPathExtension: @"docx"] atomically:YES];
		
		NSLog(@"\n\n-----------------\n\nTest failed. Output written to:\n%@\n\n", temporaryDirectoryURL.path);
		[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[temporaryDirectoryURL]];
	}
}

@end
