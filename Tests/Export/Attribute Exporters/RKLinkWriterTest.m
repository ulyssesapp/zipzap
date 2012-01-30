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
    
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://the-soulmen.com/"] range:NSMakeRange(1, 1)];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://example.com/"] range:NSMakeRange(2, 1)];
    
    [RKLinkWriter tag:taggedString withLinkStylesOfAttributedString:attributedString];

    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://the-soulmen.com/\"}}{\\fldrslt b}}"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://example.com/\"}}{\\fldrslt c}}"
                          "d",
                         @"Invalid links created");
}

@end
