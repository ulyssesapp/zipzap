//
//  RKKernAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RKKernAttributeWriter.h"

@interface RKKernAttributeWriterTest : SenTestCase

@end

@implementation RKKernAttributeWriterTest

- (void)assertKerningStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:RKKernAttributeName withValue:style onWriter:[RKKernAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testStrokeWidth
{
    // Default width
    [self assertKerningStyle:nil expectedTranslation:@"abc"];
    [self assertKerningStyle:[NSNumber numberWithInt:0] expectedTranslation:@"abc"];
	
    // Setting a width
    [self assertKerningStyle:[NSNumber numberWithInt:30] expectedTranslation:@"a\\kerning1\\expnd30\\expndtw600 b\\kerning0\\expnd0\\expndtw0 c"];
}

#if !TARGET_OS_IPHONE
- (void)testStokeWidthStyleCocoaIntegration
{
    [self assertRereadingAttribute:RKKernAttributeName withUnsignedIntegerValue:30];
}
#endif

@end
