//
//  RKAdditionalParagraphStyleWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyleWriterTest.h"

#import "RKAdditionalParagraphStyle.h"
#import "RKAdditionalParagraphStyleWriter.h"
#import "RKParagraphStyleWriter.h"

@implementation RKAdditionalParagraphStyleWriterTest

- (void)testTranslation
{
    RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
    
    paragraphStyle.keepWithFollowingParagraph = YES;
    
    [attributedString addAttribute:RKAdditionalParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"a"];
    [RKAdditionalParagraphStyleWriter addTagsForAttribute:RKAdditionalParagraphStyleAttributeName value:paragraphStyle effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil conversionPolicy:0 resources:nil];
    
    // Test with default settings
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\keepn "
                         "a",
                         @"Invalid translation"
                         );
}

- (void)testOverrideParagraphStyleSettings
{
    RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];

	additionalParagraphStyle.overrideLineHeightAndSpacing = YES;
	additionalParagraphStyle.baselineDistance = 10;
    
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle new];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];

	[attributedString addAttribute:RKAdditionalParagraphStyleAttributeName value:additionalParagraphStyle range:NSMakeRange(0,1)];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];

    RKTaggedString * taggedString = [RKTaggedString taggedStringWithString:@"a"];
    [RKParagraphStyleWriter addTagsForAttribute:NSParagraphStyleAttributeName value:paragraphStyle effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:attributedString conversionPolicy:0 resources:nil];
    [RKAdditionalParagraphStyleWriter addTagsForAttribute:NSParagraphStyleAttributeName value:additionalParagraphStyle effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:attributedString conversionPolicy:0 resources:nil];
	
	
    // Test with default settings
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\pard \\pardeftab0\\tx560\\tx1120\\tx1680\\tx2240\\tx2800\\tx3360\\tx3920\\tx4480\\tx5040\\tx5600\\tx6160\\tx6720 \\sl200\\slmult0"
                         "a",
                         @"Invalid translation"
                         );

}

@end
