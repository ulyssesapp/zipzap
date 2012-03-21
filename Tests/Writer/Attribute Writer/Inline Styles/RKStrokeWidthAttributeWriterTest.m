//
//  RKStrokeWidthAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStrokeWidthAttributeWriter.h"
#import "RKStrokeWidthAttributeWriterTest.h"
#import "SenTestCase+RKAttributeWriterTestHelper.h"

@implementation RKStrokeWidthAttributeWriterTest

- (void)assertStrokeWidthStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:RKStrokeWidthAttributeName withValue:style onWriter:[RKStrokeWidthAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testStrokeWidth
{
    // Default width
    [self assertStrokeWidthStyle:nil expectedTranslation:@"abc"];
    [self assertStrokeWidthStyle:[NSNumber numberWithInt:0] expectedTranslation:@"abc"];

    // Setting a width
    [self assertStrokeWidthStyle:[NSNumber numberWithInt:30] expectedTranslation:@"a\\outl\\strokewidth600 b\\outl0\\strokewidth0 c"];
}

#if !TARGET_OS_IPHONE
- (void)testStokeWidthStyleCocoaIntegration
{
    [self assertRereadingAttribute:RKStrokeWidthAttributeName withUnsignedIntegerValue:30];
}
#endif

@end
