//
//  RKWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriterTest.h"

@implementation RKWriterTest

- (void)testGeneratingEmptyRTFDocument
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"empty"];
}

- (void)testGeneratingSimpleRTFDocument
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@"abcdefä \\ { }"]];
    NSData *converted = [document RTF];

    [self assertRTF: converted withTestDocument: @"simple"];
}

@end
#pragma mark - Integration tests

- (void)testGeneratingSimpleRTFD
{
    NSMutableAttributedString *originalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", NSAttachmentCharacter]];
    NSTextAttachment *image = [self textAttachmentWithName:@"image" withExtension:@"png"];

    [originalString addAttribute:NSAttachmentAttributeName value:image range:NSMakeRange(0, 1)];
    
    NSAttributedString *convertedString = [self convertAndRereadRTFD:originalString documentAttributes:nil];
    
    NSTextAttachment *convertedAttachment = [convertedString attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:NULL];
    
    STAssertEqualObjects(convertedAttachment.fileWrapper.filename, @"0.png", @"Invalid filename");
    STAssertEqualObjects(convertedAttachment.fileWrapper.regularFileContents, image.fileWrapper.regularFileContents, @"File contents differ");
}

