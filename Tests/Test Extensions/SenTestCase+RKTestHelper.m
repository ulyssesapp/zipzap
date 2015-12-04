//
//  SenTestCase+RKTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "SenTestCase+RKTestHelper.h"

#import "RKImageAttachment.h"

@implementation XCTestCase (RKTestHelper)

- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:extension subdirectory:@"Test Data/resources"];
    NSFileWrapper *wrapper;
    
    XCTAssertNotNil(url, @"Cannot build URL");
    
    NSError *error;
    wrapper = [[NSFileWrapper alloc] initWithURL:url options:NSFileWrapperReadingImmediate error:&error];
    XCTAssertNotNil(wrapper, @"Load failed with error: %@", error);
    
    return wrapper;
}

- (RKImageAttachment *)imageAttachmentWithName:(NSString *)name withExtension:(NSString *)extension margin:(RKEdgeInsets)margin
{
	return [[RKImageAttachment alloc] initWithFile:[self testFileWithName:name withExtension:extension] margin:margin];
}


#pragma mark - Temporary folders

- (NSString *)temporaryDirectoryName
{
	return [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%@%@", NSStringFromClass(self.class), NSStringFromSelector(self.invocation.selector)]];
}

- (NSString *)temporaryDirectory
{
	[[NSFileManager defaultManager] createDirectoryAtPath:self.temporaryDirectoryName withIntermediateDirectories:YES attributes:nil error:NULL];
	return self.temporaryDirectoryName;
}

- (NSURL *)temporaryDirectoryURL
{
	return [NSURL fileURLWithPath: self.temporaryDirectory];
}

- (NSURL *)newTemporarySubdirectory
{
	NSURL *subDirectory = [self.temporaryDirectoryURL URLByAppendingPathComponent: [self newUniqueIdentifier]];
	[[NSFileManager defaultManager] createDirectoryAtURL:subDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	
	// Ensure trailing slashes
	return [NSURL fileURLWithPath: subDirectory.path];
}

- (NSString *)newUniqueIdentifier
{
	// Pure UUID
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	
	// Remove dashes and make lowercase
	uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
	uuidString = uuidString.lowercaseString;
	
	return uuidString;
}

@end
