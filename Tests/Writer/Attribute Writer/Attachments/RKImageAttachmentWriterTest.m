//
//  RKImageAttachmentWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKImageAttachmentWriterTest.h"
#import "RKImageAttachmentWriter.h"
#import "RKImageAttachment.h"

@implementation RKImageAttachmentWriterTest

- (void)testPictureAttachmentsIgnored
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", RKAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKImageAttachmentWriter addTagsForAttribute:RKImageAttachmentAttributeName
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               conversionPolicy:0
                                      resources:resources
    ];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsEmbedded
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", RKAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKImageAttachmentWriter addTagsForAttribute:RKImageAttachmentAttributeName
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               conversionPolicy:RKConversionPolicyConvertAttachments
                                      resources:resources
    ];

    NSString *flattened = [taggedString flattenedRTFString];
    
    // Attachment charracter was removed
    STAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%C", RKAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
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
    #if !TARGET_OS_IPHONE
        NSString *imageName = @"image-png";
    #else
        NSString *imageName = @"image-png-ios";
    #endif
    
    NSString *expectedResult = [[NSString alloc] initWithData:[[[self imageAttachmentWithName:imageName withExtension:@"hex" margins:NSEdgeInsetsMake(0, 0, 0, 0)] imageFile] regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    STAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsUnsupportedFileType
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"jpg" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", RKAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKImageAttachmentWriter addTagsForAttribute:RKImageAttachmentAttributeName
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               conversionPolicy:RKConversionPolicyConvertAttachments
                                      resources:resources
     ];
    
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Attachment charracter was removed
    STAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%C", RKAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
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
    #if !TARGET_OS_IPHONE
        NSString *imageName = @"image-jpg";
    #else
        NSString *imageName = @"image-jpg-ios";
    #endif    
    
    NSString *expectedResult = [[NSString alloc] initWithData:[[[self imageAttachmentWithName:imageName withExtension:@"hex" margins:NSEdgeInsetsMake(0, 0, 0, 0)] imageFile] regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    STAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsReferenced
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%C--", RKAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKImageAttachmentWriter addTagsForAttribute:RKImageAttachmentAttributeName
                                          value:picture 
                                 effectiveRange:NSMakeRange(2,1) 
                                       toString:taggedString 
                                 originalString:nil 
                               conversionPolicy:RKConversionPolicyConvertAttachments|RKConversionPolicyReferenceAttachments
                                      resources:resources
     ];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0-image.png \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                        );
    
    // Image was registered
    STAssertEquals(resources.attachmentFileWrappers.count, (NSUInteger)1, @"Invalid count of file wrappers");

    NSFileWrapper *registeredFile = [resources.attachmentFileWrappers.allValues  objectAtIndex:0];
    
    STAssertEqualObjects(registeredFile.preferredFilename, @"0-image.png", @"Invalid file name");
    STAssertEqualObjects(registeredFile.regularFileContents, [[picture imageFile] regularFileContents], @"File contents differ");
}

#if !TARGET_OS_IPHONE

- (void)testPictureAttachmentCocoaIntegrationWithRTF
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTF:original documentAttributes:NULL];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        STAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    STAssertEqualObjects([converted string], @"abc", @"Invalid string content");
}

- (void)testPictureAttachmentCocoaIntegrationWithPlainRTF
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadPlainRTF:original documentAttributes:NULL];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        STAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    STAssertEqualObjects([converted string], @"abc", @"Invalid string content");    
}

- (void)testPictureAttachmentCocoaIntegrationWithRTFD
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margins:NSEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTFD:original documentAttributes:NULL];

    STAssertEqualObjects([converted string], ([NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]), @"Invalid string content"); 
    
    NSTextAttachment *convertedAttachment = [converted attribute:NSAttachmentAttributeName atIndex:1 effectiveRange:NULL];
    
    STAssertEqualObjects(convertedAttachment.fileWrapper.preferredFilename, @"0-image.png", @"Invalid filename");
    STAssertEqualObjects(convertedAttachment.fileWrapper.regularFileContents, attachment.imageFile.regularFileContents, @"File contents differ");
}

#endif

@end
