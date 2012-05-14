//
//  RKStrikethroughStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStrikethroughStyleAttributeWriter.h"
#import "RKStrikethroughStyleAttributeWriterTest.h"
#import "SenTestCase+RKAttributeWriterTestHelper.h"

@implementation RKStrikethroughStyleAttributeWriterTest

- (void)assertStrikethroughStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:RKStrikethroughStyleAttributeName withValue:style onWriter:[RKStrikethroughStyleAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testStrikethroughStyle
{
    [self assertStrikethroughStyle:nil expectedTranslation:@"abc"];
    [self assertStrikethroughStyle:[NSNumber numberWithInt: 0] expectedTranslation:@"abc"];

    [self assertStrikethroughStyle:[NSNumber numberWithInt: RKUnderlineStyleSingle] expectedTranslation:@"a\\strike\\strikestyle1 b\\strike0 c"];
    [self assertStrikethroughStyle:[NSNumber numberWithInt: RKUnderlineStyleDouble] expectedTranslation:@"a\\striked1\\strikestyle9 b\\striked0 c"];    
}

#if !TARGET_OS_IPHONE
- (void)testStrikethroughStyleCocoaIntegration
{
    [self assertRereadingAttribute:RKStrikethroughStyleAttributeName withUnsignedIntegerValue:RKUnderlineStyleSingle];
    [self assertRereadingAttribute:RKStrikethroughStyleAttributeName withUnsignedIntegerValue:RKUnderlineStyleDouble];
}
#endif

@end
