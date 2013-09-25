//
//  SenTestCase+RKTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "SenTestCase+RKTestHelper.h"

#import "RKImageAttachment.h"

@implementation SenTestCase (RKTestHelper)

- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:extension subdirectory:@"Test Data/resources"];
    NSFileWrapper *wrapper;
    
    STAssertNotNil(url, @"Cannot build URL");
    
    NSError *error;
    wrapper = [[NSFileWrapper alloc] initWithURL:url options:NSFileWrapperReadingImmediate error:&error];
    STAssertNotNil(wrapper, @"Load failed with error: %@", error);
    
    return wrapper;
}

- (RKImageAttachment *)imageAttachmentWithName:(NSString *)name withExtension:(NSString *)extension margin:(NSEdgeInsets)margin
{
	return [[RKImageAttachment alloc] initWithFile:[self testFileWithName:name withExtension:extension] margin:margin];
}

@end
