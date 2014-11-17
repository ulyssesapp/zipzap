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
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
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
    XCTAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsEmbedded
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(10, 20, 30, 40)];
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
    XCTAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%C", RKAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
    // Picture tag is properly inserted
    NSString *expectedPrefix = @"--{\\pict\\picscalex100\\picscaley100\\piccropt-200\\piccropl-400\\piccropb-600\\piccropr-800\\picwgoal560\\pichgoal420\\pngblip\n";
    NSString *expectedSuffix = @"\n}--";
    
    XCTAssertTrue([flattened hasPrefix: expectedPrefix],
                 @"Invalid picture settings"
                 );
    XCTAssertTrue([flattened hasSuffix: expectedSuffix],
                 @"Invalid picture settings"
                 );

    // Picture was properly converted
    #if !TARGET_OS_IPHONE
        NSString *imageName = @"image-png";
    #else
        NSString *imageName = @"image-png-ios";
    #endif
    
    NSString *expectedResult = [[NSString alloc] initWithData:[[[self imageAttachmentWithName:imageName withExtension:@"hex" margin:RKEdgeInsetsMake(0, 0, 0, 0)] imageFile] regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    XCTAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsNotNativeFileType
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"jpg" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
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
    XCTAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%C", RKAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
    // Picture tag is properly inserted
    NSString *expectedPrefix = @"--{\\pict\\picscalex100\\picscaley100\\piccropt0\\piccropl0\\piccropb0\\piccropr0\\picwgoal560\\pichgoal420\\pngblip\n";
    NSString *expectedSuffix = @"\n}--";
    
    XCTAssertTrue([flattened hasPrefix: expectedPrefix],
                 @"Invalid picture settings"
                 );
    XCTAssertTrue([flattened hasSuffix: expectedSuffix],
                 @"Invalid picture settings"
                 );
    
    // Picture was properly converted
    #if !TARGET_OS_IPHONE
        NSString *imageName = @"image-jpg";
    #else
        NSString *imageName = @"image-jpg-ios";
    #endif    
    
    NSString *expectedResult = [[NSString alloc] initWithData:[[[self imageAttachmentWithName:imageName withExtension:@"hex" margin:RKEdgeInsetsMake(0, 0, 0, 0)] imageFile] regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    XCTAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsReferenced
{
    RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
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
    XCTAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0-image.png \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                        );
    
    // Image was registered
    XCTAssertEqual(resources.attachmentFileWrappers.count, (NSUInteger)1, @"Invalid count of file wrappers");

    NSFileWrapper *registeredFile = [resources.attachmentFileWrappers.allValues  objectAtIndex:0];
    
    XCTAssertEqualObjects(registeredFile.preferredFilename, @"0-image.png", @"Invalid file name");
    XCTAssertEqualObjects(registeredFile.regularFileContents, [[picture imageFile] regularFileContents], @"File contents differ");
}

- (void)testWordImagesAreCompatibleWithManualReferenceTest
{
	RKImageAttachment *picture = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(10, 20, 30, 40)];
    
    // Text with an inline footnote
	NSString *loremString = [@"" stringByPaddingToLength:80 withString:@"lorem " startingAtIndex:0];
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\na%Cbc\n%@", loremString, RKAttachmentCharacter, loremString]];
    
	[original addAttribute:RKImageAttachmentAttributeName value:picture range:NSMakeRange(loremString.length + 2, 1)];
	
    // This testcase should verify that we can use "Test Data/footnote.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.
    RKDocument *document = [RKDocument documentWithAttributedString:original];
	document.footnoteAreaDividerPosition = RKTextAlignmentRight;
	document.footnoteAreaDividerSpacingBefore = 60;
	document.footnoteAreaDividerSpacingAfter = 60;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"image-word"];
}

#if !TARGET_OS_IPHONE

- (void)testPictureAttachmentCocoaIntegrationWithRTF
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTF:original documentAttributes:NULL];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        XCTAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    XCTAssertEqualObjects([converted string], @"abc", @"Invalid string content");
}

- (void)testPictureAttachmentCocoaIntegrationWithPlainRTF
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadPlainRTF:original documentAttributes:NULL];
    
    [converted enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        XCTAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    XCTAssertEqualObjects([converted string], @"abc", @"Invalid string content");    
}

- (void)testPictureAttachmentCocoaIntegrationWithRTFD
{
	RKImageAttachment *attachment = [self imageAttachmentWithName:@"image" withExtension:@"png" margin:RKEdgeInsetsMake(0, 0, 0, 0)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTFD:original documentAttributes:NULL];

    XCTAssertEqualObjects([converted string], ([NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]), @"Invalid string content"); 
    
    NSTextAttachment *convertedAttachment = [converted attribute:NSAttachmentAttributeName atIndex:1 effectiveRange:NULL];
    
    XCTAssertEqualObjects(convertedAttachment.fileWrapper.preferredFilename, @"0-image.png", @"Invalid filename");
    XCTAssertEqualObjects(convertedAttachment.fileWrapper.regularFileContents, attachment.imageFile.regularFileContents, @"File contents differ");
}

#endif

@end
