//
//  SenTestCase+RKTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "SenTestCase+RKTestHelper.h"

#import "RKTextAttachment.h"

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

- (id)textAttachmentWithName:(NSString *)name withExtension:(NSString *)extension
{
#if !TARGET_OS_IPHONE
    return [[NSTextAttachment alloc] initWithFileWrapper: [self testFileWithName:name withExtension:extension]];
#else
    return [[RKTextAttachment alloc] initWithFileWrapper: [self testFileWithName:name withExtension:extension]];
#endif
}

@end
