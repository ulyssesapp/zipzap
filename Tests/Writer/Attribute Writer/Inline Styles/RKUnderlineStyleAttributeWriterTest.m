//
//  RKUnderlineStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKUnderlineStyleAttributeWriter.h"
#import "RKUnderlineStyleAttributeWriterTest.h"
#import "SenTestCase+RKAttributeWriterTestHelper.h"

@implementation RKUnderlineStyleAttributeWriterTest

- (void)assertUnderlineStyle:(id)style expectedTranslation:(NSString *)expectedTranslation
{
    [self assertResourcelessStyle:NSUnderlineStyleAttributeName withValue:style onWriter:[RKUnderlineStyleAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testUnderlineStyle
{
    // Default style
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: 0] expectedTranslation:@"abc"];
    [self assertUnderlineStyle:nil expectedTranslation:@"abc"];
    
    // Line styles
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: NSUnderlineStyleSingle] expectedTranslation:@"a\\ul\\ulstyle1 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: NSUnderlineStyleDouble] expectedTranslation:@"a\\uldb\\ulstyle9 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: NSUnderlineStyleThick] expectedTranslation:@"a\\ulth\\ulstyle2 b\\ulnone c"];
    
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDash)] expectedTranslation:@"a\\uldash\\ulstyle513 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDashDot)] expectedTranslation:@"a\\uldashd\\ulstyle769 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot)] expectedTranslation:@"a\\uldashdd\\ulstyle1025 b\\ulnone c"];

    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleThick | NSUnderlinePatternDash)] expectedTranslation:@"a\\ulthdash\\ulstyle514 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleThick | NSUnderlinePatternDashDot)] expectedTranslation:@"a\\ulthdashd\\ulstyle770 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleThick | NSUnderlinePatternDashDotDot)] expectedTranslation:@"a\\ulthdashdd\\ulstyle1026 b\\ulnone c"];
    
    // Wordwise (additional styles are placed after \ulw)
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleSingle | NSUnderlineStyleSingle | NSUnderlineByWordMask)] 
           expectedTranslation:@"a\\ulw\\ulstyle32769 b\\ulnone c"
    ];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (NSUnderlineStyleSingle | NSUnderlineStyleDouble | NSUnderlineByWordMask)] 
           expectedTranslation:@"a\\ulw\\uldb\\ulstyle32777 b\\ulnone c"
    ];
}

- (void)testUnderlineStyleCocoaIntegration
{
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleSingle];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleDouble];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleThick];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDash)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDashDot)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot)];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDash)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDashDot)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDashDotDot)];
    
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDash)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDashDot)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDashDotDot)];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlineByWordMask)];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDash | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDash | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDash | NSUnderlineByWordMask)];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDashDot | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDashDot | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDashDot | NSUnderlineByWordMask)];

    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleDouble | NSUnderlinePatternDashDotDot | NSUnderlineByWordMask)];
    [self assertRereadingAttribute:NSUnderlineStyleAttributeName withUnsignedIntegerValue:(NSUnderlineStyleThick | NSUnderlinePatternDashDotDot | NSUnderlineByWordMask)];
}

@end
