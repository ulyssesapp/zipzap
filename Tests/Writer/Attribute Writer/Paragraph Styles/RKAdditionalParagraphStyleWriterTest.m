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

@implementation RKAdditionalParagraphStyleWriterTest

- (void)testTranslation
{
    RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
    
    paragraphStyle.keepWithFollowingParagraph = YES;
    
    [attributedString addAttribute:RKAdditionalParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"a"];
    [RKAdditionalParagraphStyleWriter addTagsForAttribute:RKAdditionalParagraphStyleAttributeName value:paragraphStyle effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil attachmentPolicy:0 resources:nil];
    
    // Test with default settings
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\keepn "
                         "a",
                         @"Invalid translation"
                         );
}

@end
