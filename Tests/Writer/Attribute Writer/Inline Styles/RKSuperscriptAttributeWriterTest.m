//
//  RKSuperscriptAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSuperscriptAttributeWriter.h"
#import "RKSuperscriptAttributeWriterTest.h"
#import "RKAttributeWriterTestHelper.h"

@implementation RKSuperscriptAttributeWriterTest

- (void)assertSuperscriptStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:NSSuperscriptAttributeName withValue:style onWriter:[RKSuperscriptAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testSuperscriptMode
{
    // Default mode
    [self assertSuperscriptStyle:[NSNumber numberWithInt: 0] expectedTranslation:@"abc"];
    [self assertSuperscriptStyle:nil expectedTranslation:@"abc"];
    
    // Setting superscript
    [self assertSuperscriptStyle:[NSNumber numberWithInt: 1] expectedTranslation:@"a\\sup b\\sup0 c"];
    
    // Setting subscript
    [self assertSuperscriptStyle:[NSNumber numberWithInt: -1] expectedTranslation:@"a\\sub b\\sub0 c"];
}

- (void)testSuperscriptCocoaIntegrationTest
{
    [self assertRereadingAttribute:NSStrokeWidthAttributeName withIntegerValue:1];
    [self assertRereadingAttribute:NSStrokeWidthAttributeName withIntegerValue:-1];
}

@end
