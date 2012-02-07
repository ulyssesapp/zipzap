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
    
    [RKLinkWriter addTagsForAttribute:[NSURL URLWithString:@"http://the-soulmen.com/"] toTaggedString:taggedString inRange:NSMakeRange(1,1) withAttachmentPolicy:0 resources:nil];
    [RKLinkWriter addTagsForAttribute:@"http://example.com/" toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:0 resources:nil];
    
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://the-soulmen.com/\"}}{\\fldrslt b}}"
                          "{\\field{\\*\\fldinst{HYPERLINK \"http://example.com/\"}}{\\fldrslt c}}"
                          "d",
                         @"Invalid links created");
}

- (void)testLinkAttachmentCocoaIntegration
{
    NSString *linkA = [NSURL URLWithString: @"http://google.de"];
    NSString *linkB = [NSURL URLWithString: @"http://the-soulmen.com"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSLinkAttributeName value:linkA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSLinkAttributeName value:linkB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSLinkAttributeName inRange:NSMakeRange(0,3)];
}

@end
