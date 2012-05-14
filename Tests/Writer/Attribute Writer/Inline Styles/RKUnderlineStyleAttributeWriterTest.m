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
    [self assertResourcelessStyle:RKUnderlineStyleAttributeName withValue:style onWriter:[RKUnderlineStyleAttributeWriter class] expectedTranslation:expectedTranslation];
}

- (void)testUnderlineStyle
{
    // Default style
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: 0] expectedTranslation:@"abc"];
    [self assertUnderlineStyle:nil expectedTranslation:@"abc"];
    
    // Line styles
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: RKUnderlineStyleSingle] expectedTranslation:@"a\\ul\\ulstyle1 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: RKUnderlineStyleDouble] expectedTranslation:@"a\\uldb\\ulstyle9 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: RKUnderlineStyleThick] expectedTranslation:@"a\\ulth\\ulstyle2 b\\ulnone c"];
    
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleSingle | RKUnderlinePatternDash)] expectedTranslation:@"a\\uldash\\ulstyle513 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleSingle | RKUnderlinePatternDashDot)] expectedTranslation:@"a\\uldashd\\ulstyle769 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleSingle | RKUnderlinePatternDashDotDot)] expectedTranslation:@"a\\uldashdd\\ulstyle1025 b\\ulnone c"];

    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleThick | RKUnderlinePatternDash)] expectedTranslation:@"a\\ulthdash\\ulstyle514 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleThick | RKUnderlinePatternDashDot)] expectedTranslation:@"a\\ulthdashd\\ulstyle770 b\\ulnone c"];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleThick | RKUnderlinePatternDashDotDot)] expectedTranslation:@"a\\ulthdashdd\\ulstyle1026 b\\ulnone c"];
    
    #if !TARGET_OS_IPHONE
    // Wordwise (additional styles are placed after \ulw)
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleSingle | RKUnderlineStyleSingle | RKUnderlineByWordMask)] 
           expectedTranslation:@"a\\ulw\\ulstyle32769 b\\ulnone c"
    ];
    [self assertUnderlineStyle:[NSNumber numberWithUnsignedInteger: (RKUnderlineStyleSingle | RKUnderlineStyleDouble | RKUnderlineByWordMask)] 
           expectedTranslation:@"a\\ulw\\uldb\\ulstyle32777 b\\ulnone c"
    ];
    #endif
}

#if !TARGET_OS_IPHONE
- (void)testUnderlineStyleCocoaIntegration
{
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:RKUnderlineStyleSingle];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:RKUnderlineStyleDouble];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:RKUnderlineStyleThick];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDash)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDashDot)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDashDotDot)];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDash)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDashDot)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDashDotDot)];
    
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDash)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDashDot)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDashDotDot)];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlineByWordMask)];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDash | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDash | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDash | RKUnderlineByWordMask)];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDashDot | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDashDot | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDashDot | RKUnderlineByWordMask)];

    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleSingle | RKUnderlinePatternDashDotDot | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleDouble | RKUnderlinePatternDashDotDot | RKUnderlineByWordMask)];
    [self assertRereadingAttribute:RKUnderlineStyleAttributeName withUnsignedIntegerValue:(RKUnderlineStyleThick | RKUnderlinePatternDashDotDot | RKUnderlineByWordMask)];
}

- (void)testRereadUnderlineStyleWithLinks
{
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString: @"Foo"];
    
    [testString addAttribute:RKUnderlineStyleAttributeName value:[NSNumber numberWithInteger: RKUnderlineStyleSingle] range:NSMakeRange(0, 1)];
    [testString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://the-soulmen.com"] range:NSMakeRange(0, 1)];

    [self assertReadingOfAttributedString:testString onAttribute:RKUnderlineStyleAttributeName inRange:NSMakeRange(0, 3)];
    [self assertReadingOfAttributedString:testString onAttribute:RKLinkAttributeName inRange:NSMakeRange(0, 3)];
}

#endif

@end
