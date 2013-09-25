//
//  NSAttributedStringPersistenceTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedStringPersistenceTest.h"

#import "RKParagraphStyleWrapper.h"
#import "RKImageAttachment.h"

extern NSString *RKPersistenceStringContentKey;
extern NSString *RKPersistenceAttributeRangesKey;
extern NSString *RKPersistenceContextKey;

extern NSString *RKPersistenceAttributeRangeKey;
extern NSString *RKPersistenceAttributeValuesKey;

extern NSString *RKPersistenceRangeLocationKey;
extern NSString *RKPersistenceRangeLengthKey;

extern NSString *RKPersistenceContextFileWrappersPersistenceKey;
extern NSString *RKPersistenceContextListStylesPersistenceKey;

@implementation NSAttributedStringPersistenceTest

#if !TARGET_OS_IPHONE

+ (id)plattformColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [NSColor colorWithCalibratedRed:0.1 green:0.3 blue:0.2 alpha:0.1];
}

#else

+ (id)plattformColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace, (CGFloat[]){red, green, blue, alpha});
    CFRelease (colorSpace);
    return (__bridge id)color;
}

#endif

- (void)testPersistingUnstyledString
{
    NSAttributedString *unstyled = [[NSAttributedString alloc] initWithString: @"This is a String!"];

    NSDictionary *plist = [unstyled RTFKitPropertyListRepresentation];
    
    STAssertEqualObjects(plist[RKPersistenceStringContentKey], @"This is a String!", @"String not properly serialized");
    STAssertEquals([plist[RKPersistenceAttributeRangesKey] count], 0UL, @"No attribute ranges expected");

    STAssertEquals([plist[RKPersistenceContextKey][RKPersistenceContextFileWrappersPersistenceKey] count], 0UL, @"No context data expected");
    STAssertEquals([plist[RKPersistenceContextKey][RKPersistenceContextListStylesPersistenceKey] count], 0UL, @"No context data expected");

    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(unstyled, reparsed, @"Error in serialization");
}

- (void)testPersistingSimpleStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-BoldOblique"), 32, NULL);
    
    [original addAttribute:RKFontAttributeName value:(__bridge id)font range:NSMakeRange(1,2)];
    [original addAttribute:RKBackgroundColorAttributeName value:[self.class plattformColorWithRed:0.1 green:0.2 blue:0.3 alpha:0.4] range:NSMakeRange(1,2)];

    CFRelease(font);
    
    // Different range
    [original addAttribute:RKUnderlineStyleAttributeName value:@(2) range:NSMakeRange(3,3)];
    [original addAttribute:RKStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(3,3)];
    [original addAttribute:RKStrokeWidthAttributeName value:@(1) range:NSMakeRange(3,3)];
        
    [original addAttribute:RKBackgroundColorAttributeName value:[self.class plattformColorWithRed:0.1 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:RKForegroundColorAttributeName value:[self.class plattformColorWithRed:0.2 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:RKUnderlineColorAttributeName value:[self.class plattformColorWithRed:0.3 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:RKStrikethroughColorAttributeName value:[self.class plattformColorWithRed:0.4 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:RKStrokeColorAttributeName value:[self.class plattformColorWithRed:0.5 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    
    #if !TARGET_OS_IPHONE
        NSShadow *shadow = [NSShadow new];
        shadow.shadowColor = [self.class plattformColorWithRed:0.6 green:0.3 blue:0.2 alpha:0.1];
    #else
        RKShadow *shadow = [RKShadow new];
        shadow.shadowColor = (__bridge CGColorRef)[self.class plattformColorWithRed:0.6 green:0.3 blue:0.2 alpha:0.1];
    #endif

    shadow.shadowBlurRadius = 4.0f;
    shadow.shadowOffset = CGSizeMake(33.0f, 55.0f);
    
    [original addAttribute:RKShadowAttributeName value:shadow range:NSMakeRange(3,5)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

- (void)testPersistingEmptyParagraphStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"Paragraph A\nParagraph B\nParagraph C\n"];
    
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    
    STAssertEqualObjects(plist[RKPersistenceStringContentKey], @"Paragraph A\nParagraph B\nParagraph C\n", @"String not properly serialized");
    STAssertEquals([plist[RKPersistenceAttributeRangesKey] count], 0UL, @"No attribute ranges expected");
    
    STAssertEquals([plist[RKPersistenceContextKey][RKPersistenceContextFileWrappersPersistenceKey] count], 0UL, @"No context data expected");
    STAssertEquals([plist[RKPersistenceContextKey][RKPersistenceContextListStylesPersistenceKey] count], 0UL, @"No context data expected");
    
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

#if !TARGET_OS_IPHONE
- (void)testPersistingSimpleParagraphStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"A\nB\nC\n"];

    NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    [original addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(2,4)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}
#else
- (void)testPersistingSimpleParagraphStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"A\nB\nC\n"];
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(NULL, 0);
    [original addAttribute:RKParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(2,4)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}
#endif

- (void)testAttachments
{
    NSFileWrapper *file = [[NSFileWrapper alloc] initRegularFileWithContents: [@"abc" dataUsingEncoding: NSUTF8StringEncoding]];
    file.filename = @"someFile";

    RKImageAttachment *attachment = [[RKImageAttachment alloc] initWithFile:file margin:NSEdgeInsetsMake(1, 2, 3, 4)];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:@"\ufffc"];
    [original addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(0, 1)];

    // Test re-reading (an immediate comparison is not possible, since attachments cannot be compared directly)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original.string, reparsed.string, @"Error in serialization");
    
    RKImageAttachment *reparsedAttachment = [reparsed attribute:RKImageAttachmentAttributeName atIndex:0 effectiveRange:NULL];
    NSFileWrapper *reparsedFile = reparsedAttachment.imageFile;
    
    STAssertFalse(attachment == reparsedAttachment, @"Attachment should not be equal!");
    STAssertFalse(file == reparsedFile, @"Attachment should not be equal!");
    
    STAssertEqualObjects(reparsedFile.filename, file.filename, @"Filenames should be equal");
    STAssertEqualObjects(reparsedFile.regularFileContents, file.regularFileContents, @"File contents should be equal");
	STAssertEquals(reparsedAttachment.margin, attachment.margin, @"Margins should be equal.");
}

- (void)testLinks
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range: NSURL
    [original addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://the-soulmen.com/"] range:NSMakeRange(1,2)];
    
    // Different range: NSString
    [original addAttribute:RKLinkAttributeName value:@"http://www.the-soulmen.com/" range:NSMakeRange(3,3)];
    
    // Test re-reading (direct comparison fails, since the NSString is re-parsed as NSURL)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];

    NSURL *firstURL = [reparsed attribute:RKLinkAttributeName atIndex:1 effectiveRange:NULL];
    NSURL *secondURL = [reparsed attribute:RKLinkAttributeName atIndex:3 effectiveRange:NULL];
    
    STAssertEqualObjects(firstURL.absoluteString, @"http://the-soulmen.com/", @"Link not correctly converted");
    STAssertEqualObjects(secondURL.absoluteString, @"http://www.the-soulmen.com/", @"Link not correctly converted");
}

- (void)testFootnotes
{
    NSAttributedString *footnote = [[NSAttributedString alloc] initWithString: @"Some string!"];
    NSAttributedString *original = [NSAttributedString attributedStringWithFootnote: footnote];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

- (void)testEndnotes
{
    NSAttributedString *endnote = [[NSAttributedString alloc] initWithString: @"Some string!"];
    NSAttributedString *original = [NSAttributedString attributedStringWithEndnote: endnote];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

- (void)testFootnotesWithAttachment
{
    // Build footnote
    NSFileWrapper *file = [[NSFileWrapper alloc] initRegularFileWithContents: [@"abc" dataUsingEncoding: NSUTF8StringEncoding]];
    file.filename = @"someFile";
    
    RKImageAttachment *attachment = [[RKImageAttachment alloc] initWithFile:file margin:NSEdgeInsetsMake(1, 2, 3, 4)];
    
    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:@"\ufffc"];
    [footnote addAttribute:RKImageAttachmentAttributeName value:attachment range:NSMakeRange(0, 1)];

    // Build container
    NSAttributedString *original = [NSAttributedString attributedStringWithFootnote: footnote];
    
    // Test re-reading (an immediate comparison is not possible, since attachments cannot be compared directly)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original.string, reparsed.string, @"Error in serialization");
    
    NSAttributedString *reparsedFootnote = [reparsed attribute:RKFootnoteAttributeName atIndex:0 effectiveRange:NULL];
    
    RKImageAttachment *reparsedAttachment = [reparsedFootnote attribute:RKImageAttachmentAttributeName atIndex:0 effectiveRange:NULL];
    NSFileWrapper *reparsedFile = reparsedAttachment.imageFile;
    
    STAssertFalse(attachment == reparsedAttachment, @"Attachment should not be equal!");
    STAssertFalse(file == reparsedFile, @"Attachment should not be equal!");
    
    STAssertEqualObjects(reparsedFile.filename, file.filename, @"Filenames should be equal");
    STAssertEqualObjects(reparsedFile.regularFileContents, file.regularFileContents, @"File contents should be equal");
	STAssertEquals(reparsedAttachment.margin, attachment.margin, @"Margins should be equal.");
}

- (void)testListStyles
{
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%a.", nil]
															styles:@[@{NSParagraphStyleAttributeName: [NSParagraphStyle new], RKListStyleMarkerLocationKey: @1, RKListStyleMarkerWidthKey: @2}]
                                                      startNumbers:[NSArray arrayWithObjects:
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 3],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],
                                                                    [NSNumber numberWithInteger: 1],                                                                 
                                                                    nil
                                                                    ]
                             ];
    
    NSAttributedString *originalString = [NSAttributedString attributedStringWithListItem:[[NSAttributedString alloc] initWithString:@"A"] usingStyle:textList withIndentationLevel:2];

    // Test re-reading (an immediate comparison is not possible, so we compare the items)
    NSDictionary *plist = [originalString RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];

    RKListItem *originalItem = [originalString attribute:RKTextListItemAttributeName atIndex:0 effectiveRange:NULL];
    RKListItem *reparsedItem = [reparsed attribute:RKTextListItemAttributeName atIndex:0 effectiveRange:NULL];
    
    STAssertFalse(originalItem == reparsedItem, @"Items must not be identical");
    
    STAssertTrue([originalItem isEqualToListItem: reparsedItem], @"Items must be equal");
}

- (void)testAdditionalParagraphStyles
{
	RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
	paragraphStyle.keepWithFollowingParagraph = YES;
	
	NSAttributedString *originalString = [[NSAttributedString alloc] initWithString: @"abc" attributes:[NSDictionary dictionaryWithObject:paragraphStyle forKey:RKAdditionalParagraphStyleAttributeName]];
	
	NSDictionary *plist = [originalString RTFKitPropertyListRepresentation];
	NSAttributedString *reparsedString = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
	
	RKAdditionalParagraphStyle *reparsedStyle = [reparsedString attribute:RKAdditionalParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	STAssertEqualObjects(paragraphStyle, reparsedStyle, @"Invalid deserialization.");
}

@end
