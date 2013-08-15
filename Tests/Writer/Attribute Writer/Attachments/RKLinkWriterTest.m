//
//  RKLinkWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKLinkWriterTest.h"
#import "RKLinkWriter.h"

@implementation RKLinkWriterTest

- (void)testLinkWriter
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abcd"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];

    [RKLinkWriter addTagsForAttribute:RKLinkAttributeName 
                                value:[NSURL URLWithString:@"http://the-soulmen.com/"] 
                       effectiveRange:NSMakeRange(1,1) 
                             toString:taggedString 
                       originalString:nil 
                     conversionPolicy:0
                            resources:nil
     ];    

    [RKLinkWriter addTagsForAttribute:RKLinkAttributeName 
                                value:[NSURL URLWithString:@"http://example.com/"] 
                       effectiveRange:NSMakeRange(2,1) 
                             toString:taggedString 
                       originalString:nil 
                     conversionPolicy:0
                            resources:nil
     ];      
    
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://the-soulmen.com/\"}}{\\fldrslt b}}"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://example.com/\"}}{\\fldrslt c}}"
                          "d",
                         @"Invalid links created");
}

#if !TARGET_OS_IPHONE
- (void)testLinkAttachmentCocoaIntegration
{
    NSString *linkA = [NSURL URLWithString: @"http://google.de"];
    NSString *linkB = [NSURL URLWithString: @"http://the-soulmen.com"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:RKLinkAttributeName value:linkA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:RKLinkAttributeName value:linkB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:RKLinkAttributeName inRange:NSMakeRange(0,3)];
}
#endif

@end
