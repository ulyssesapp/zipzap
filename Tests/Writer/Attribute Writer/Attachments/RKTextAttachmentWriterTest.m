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
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsEmbedded
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyEmbed resources:resources];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Attachment charracter was removed
    STAssertTrue(([flattened rangeOfString:[NSString stringWithFormat:@"%c", NSAttachmentCharacter]].location == NSNotFound), @"Attachment charracter not removed");
    
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
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyEmbed resources:resources];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsReferenced
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyReference resources:resources];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.png \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                        );
    
    // Image was registered
    STAssertEquals([resources fileWrappers].count, (NSUInteger)1, @"Invalid count of file wrappers");

    NSFileWrapper *registeredFile = [[resources fileWrappers] objectAtIndex:0];
    
    STAssertTrue(registeredFile != picture.fileWrapper, @"File wrapper was not duplicated");
    STAssertEqualObjects([registeredFile filename], @"0.png", @"Invalid file name");
    STAssertEqualObjects([registeredFile regularFileContents], [picture.fileWrapper regularFileContents], @"File contents differ");
}

- (void)testMovieAttachmentsReferenced
{
    NSTextAttachment *picture = [self textAttachmentWithName:@"movie" withExtension:@"mov"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyReference resources:resources];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.mov \\width0 \\height0}¬}"
                         "--",
                         @"Invalid tag generated"
                         );
    
    // Image was registered
    STAssertEquals([resources fileWrappers].count, (NSUInteger)1, @"Invalid count of file wrappers");
    
    NSFileWrapper *registeredFile = [[resources fileWrappers] objectAtIndex:0];
    
    STAssertTrue(registeredFile != picture.fileWrapper, @"File wrapper was not duplicated");
    STAssertEqualObjects([registeredFile filename], @"0.mov", @"Invalid file name");
    STAssertEqualObjects([registeredFile regularFileContents], [picture.fileWrapper regularFileContents], @"File contents differ");
}

@end
