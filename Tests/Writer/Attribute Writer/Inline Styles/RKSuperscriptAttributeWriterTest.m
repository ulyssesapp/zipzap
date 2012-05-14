//
//  RKSuperscriptAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSuperscriptAttributeWriter.h"
#import "RKSuperscriptAttributeWriterTest.h"
#import "SenTestCase+RKAttributeWriterTestHelper.h"

@implementation RKSuperscriptAttributeWriterTest

- (void)assertSuperscriptStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:RKSuperscriptAttributeName withValue:style onWriter:[RKSuperscriptAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testSuperscriptMode
{
    // Default mode
    [self assertSuperscriptStyle:[NSNumber numberWithInt: 0] expectedTranslation:@"abc"];
    [self assertSuperscriptStyle:nil expectedTranslation:@"abc"];
    
    // Setting superscript
    [self assertSuperscriptStyle:[NSNumber numberWithInt: 1] expectedTranslation:@"a\\super b\\super0 c"];
    
    // Setting subscript
    [self assertSuperscriptStyle:[NSNumber numberWithInt: -1] expectedTranslation:@"a\\sub b\\sub0 c"];
}

#if !TARGET_OS_IPHONE
- (void)testSuperscriptCocoaIntegrationTest
{
    [self assertRereadingAttribute:RKSuperscriptAttributeName withIntegerValue:1];
    [self assertRereadingAttribute:RKSuperscriptAttributeName withIntegerValue:-1];
}
#endif

@end
