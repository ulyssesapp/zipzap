//
//  RKTextAttachmentWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextAttachmentWriterTest.h"
#import "RKTextAttachmentWriter.h"

@implementation RKTextAttachmentWriterTest

- (void)testPictureAttachmentsIgnored
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:NSAttachmentAttributeName 
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               attachmentPolicy:RKAttachmentPolicyIgnore 
                                      resources:resources
    ];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsEmbedded
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:NSAttachmentAttributeName 
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               attachmentPolicy:RKAttachmentPolicyEmbed
                                      resources:resources
    ];

    NSString *flattened = [taggedString flattenedRTFString];
    
    // Attachment charracter was removed
    STAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%C", NSAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
    // Picture tag is properly inserted
    NSString *expectedPrefix = @"--{\\pict\\picscalex100\\picscaley100\\pngblip\n";
    NSString *expectedSuffix = @"\n}--";
    
    STAssertTrue([flattened hasPrefix: expectedPrefix],
                 @"Invalid picture settings"
                 );
    STAssertTrue([flattened hasSuffix: expectedSuffix],
                 @"Invalid picture settings"
                 );

    // Picture was properly converted
    NSString *expectedResult = [[NSString alloc] initWithData:[[self textAttachmentWithName:@"image" withExtension:@"hex"].fileWrapper regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    STAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsUnsupportedFileType
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"jpg"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:NSAttachmentAttributeName 
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               attachmentPolicy:RKAttachmentPolicyEmbed
                                      resources:resources
     ];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsReferenced
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:NSAttachmentAttributeName 
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               attachmentPolicy:RKAttachmentPolicyReference
                                      resources:resources
     ];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.png \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                        );
    
    // Image was registered
    STAssertEquals(resources.attachmentFileWrappers.count, (NSUInteger)1, @"Invalid count of file wrappers");

    NSFileWrapper *registeredFile = [resources.attachmentFileWrappers.allValues  objectAtIndex:0];
    
    STAssertEqualObjects(registeredFile.preferredFilename, @"0.png", @"Invalid file name");
    STAssertEqualObjects(registeredFile.regularFileContents, [picture.fileWrapper regularFileContents], @"File contents differ");
}

- (void)testMovieAttachmentsReferenced
{
    NSTextAttachment *movie = [self textAttachmentWithName:@"movie" withExtension:@"mov"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:NSAttachmentAttributeName 
                                          value:movie 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               attachmentPolicy:RKAttachmentPolicyReference
                                      resources:resources
     ];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.mov \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                         );
    
    // Image was registered
    STAssertEquals(resources.attachmentFileWrappers.count, (NSUInteger)1, @"Invalid count of file wrappers");
    
    NSFileWrapper *registeredFile = [resources.attachmentFileWrappers.allValues objectAtIndex:0];
    
    STAssertEqualObjects(registeredFile.preferredFilename, @"0.mov", @"Invalid file name");
    STAssertEqualObjects(registeredFile.regularFileContents, [movie.fileWrapper regularFileContents], @"File contents differ");
}

- (void)testPictureAttachmentCocoaIntegrationWithRTF
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", NSAttachmentCharacter]];
    
    [original addAttribute:NSAttachmentAttributeName value:picture range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTF:original documentAttributes:nil];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        STAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    STAssertEqualObjects([converted string], @"abc\n", @"Invalid string content");    
}

- (void)testPictureAttachmentCocoaIntegrationWithPlainRTF
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", NSAttachmentCharacter]];
    
    [original addAttribute:NSAttachmentAttributeName value:picture range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadPlainRTF:original documentAttributes:nil];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        STAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    STAssertEqualObjects([converted string], @"abc\n", @"Invalid string content");    
}

- (void)testPictureAttachmentCocoaIntegrationWithRTFD
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", NSAttachmentCharacter]];
    
    [original addAttribute:NSAttachmentAttributeName value:picture range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTFD:original documentAttributes:nil];

    STAssertEqualObjects([converted string], ([NSString stringWithFormat:@"a%Cbc\n", NSAttachmentCharacter]), @"Invalid string content"); 
    
    NSTextAttachment *convertedAttachment = [converted attribute:NSAttachmentAttributeName atIndex:1 effectiveRange:NULL];
    
    STAssertEqualObjects(convertedAttachment.fileWrapper.preferredFilename, @"0.png", @"Invalid filename");
    STAssertEqualObjects(convertedAttachment.fileWrapper.regularFileContents, picture.fileWrapper.regularFileContents, @"File contents differ");
}

- (void)testMovieAttachmentCocoaIntegrationWithRTFD
{
    NSTextAttachment *movie = [self textAttachmentWithName:@"movie" withExtension:@"mov"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", NSAttachmentCharacter]];
    
    [original addAttribute:NSAttachmentAttributeName value:movie range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTFD:original documentAttributes:nil];
    
    STAssertEqualObjects([converted string], ([NSString stringWithFormat:@"a%Cbc\n", NSAttachmentCharacter]), @"Invalid string content"); 
    
    NSTextAttachment *convertedAttachment = [converted attribute:NSAttachmentAttributeName atIndex:1 effectiveRange:NULL];
    
    STAssertEqualObjects(convertedAttachment.fileWrapper.preferredFilename, @"0.mov", @"Invalid filename");
    STAssertEqualObjects(convertedAttachment.fileWrapper.regularFileContents, movie.fileWrapper.regularFileContents, @"File contents differ");
}

@end
