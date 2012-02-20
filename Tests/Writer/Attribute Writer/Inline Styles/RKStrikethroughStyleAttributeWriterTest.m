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
    [self assertResourcelessStyle:NSStrikethroughStyleAttributeName withValue:style onWriter:[RKStrikethroughStyleAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testStrikethroughStyle
{
    [self assertStrikethroughStyle:nil expectedTranslation:@"abc"];
    [self assertStrikethroughStyle:[NSNumber numberWithInt: 0] expectedTranslation:@"abc"];

    [self assertStrikethroughStyle:[NSNumber numberWithInt: NSUnderlineStyleSingle] expectedTranslation:@"a\\strike\\strikestyle1 b\\strike0 c"];
    [self assertStrikethroughStyle:[NSNumber numberWithInt: NSUnderlineStyleDouble] expectedTranslation:@"a\\striked1\\strikestyle9 b\\striked0 c"];    
}

- (void)testStrikethroughStyleCocoaIntegration
{
    [self assertRereadingAttribute:NSStrikethroughStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleSingle];
    [self assertRereadingAttribute:NSStrikethroughStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleDouble];
}

@end
