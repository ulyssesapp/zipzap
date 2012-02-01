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

- (NSFileWrapper *)attachmentWithName:(NSString *)name withExtension:(NSString *)extension
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:extension subdirectory:@"Test Data/resources"];
    NSFileWrapper *wrapper;
    
    STAssertNotNil(url, @"Cannot build URL");
    
    NSError *error;
    wrapper = [[NSFileWrapper alloc] initWithURL:url options:NSFileWrapperReadingImmediate error:&error];
    STAssertNotNil(wrapper, @"Load failed with error: %@", error);
    
    return wrapper;
}

- (void)testPictureAttachmentsIgnored
{
    NSFileWrapper *picture = [self attachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsEmbedded
{
    NSFileWrapper *picture = [self attachmentWithName:@"image" withExtension:@"png"];
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
    NSString *expectedResult = [[NSString alloc] initWithData:[[self attachmentWithName:@"image" withExtension:@"hex"] regularFileContents] encoding:NSASCIIStringEncoding ];
    NSString *testedResult = [flattened substringWithRange:NSMakeRange([expectedPrefix length], [flattened length] - [expectedPrefix length] - [expectedSuffix length])];
    
    STAssertEqualObjects(testedResult, expectedResult, @"Invalid file encoding");
}

- (void)testPictureAttachmentsUnsupportedFileType
{
    NSFileWrapper *picture = [self attachmentWithName:@"image" withExtension:@"jpg"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyEmbed resources:resources];
    
    // No picture should have been embedded and the attachment charracter should have been removed
    STAssertEqualObjects([taggedString flattenedRTFString], @"----", @"Picture was not ignored");
}

- (void)testPictureAttachmentsReferenced
{
    NSFileWrapper *picture = [self attachmentWithName:@"image" withExtension:@"png"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyReference resources:resources];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.png}\172}"
                         "--",
                         @"Invalid tag generated"
                        );
    
    // Image was registered
    STAssertEquals([resources fileWrappers].count, (NSUInteger)1, @"Invalid count of file wrappers");

    NSFileWrapper *registeredFile = [[resources fileWrappers] objectAtIndex:0];
    
    STAssertTrue(registeredFile != picture, @"File wrapper was not duplicated");
    STAssertEqualObjects([registeredFile filename], @"0.png", @"Invalid file name");
    STAssertEqualObjects([registeredFile regularFileContents], [picture regularFileContents], @"File contents differ");
}

- (void)testMovieAttachmentsReferenced
{
    NSFileWrapper *picture = [self attachmentWithName:@"movie" withExtension:@"mov"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@"--%c--", NSAttachmentCharacter]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKTextAttachmentWriter addTagsForAttribute:picture toTaggedString:taggedString inRange:NSMakeRange(2,1) withAttachmentPolicy:RKAttachmentPolicyReference resources:resources];
    NSString *flattened = [taggedString flattenedRTFString];
    
    // Correct tag placement
    STAssertEqualObjects(flattened,
                         @"--"
                         "{{\\NeXTGraphic 0.mov}\172}"
                         "--",
                         @"Invalid tag generated"
                         );
    
    // Image was registered
    STAssertEquals([resources fileWrappers].count, (NSUInteger)1, @"Invalid count of file wrappers");
    
    NSFileWrapper *registeredFile = [[resources fileWrappers] objectAtIndex:0];
    
    STAssertTrue(registeredFile != picture, @"File wrapper was not duplicated");
    STAssertEqualObjects([registeredFile filename], @"0.mov", @"Invalid file name");
    STAssertEqualObjects([registeredFile regularFileContents], [picture regularFileContents], @"File contents differ");
}

@end
