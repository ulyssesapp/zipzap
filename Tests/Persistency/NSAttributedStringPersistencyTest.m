//
//  NSAttributedStringPersistencyTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedStringPersistencyTest.h"

#import "NSAttributedString+RKPersistency.h"

extern NSString *RKPersistencyStringContentKey;
extern NSString *RKPersistencyAttributeRangesKey;
extern NSString *RKPersistencyContextKey;

extern NSString *RKPersistencyAttributeRangeKey;
extern NSString *RKPersistencyAttributeValuesKey;

extern NSString *RKPersistencyRangeLocationKey;
extern NSString *RKPersistencyRangeLengthKey;

extern NSString *RKPersistencyContextFileWrappersPersistencyKey;
extern NSString *RKPersistencyContextListStylesPersistencyKey;

@implementation NSAttributedStringPersistencyTest

- (void)testPersistingUnstyledString
{
    NSAttributedString *unstyled = [[NSAttributedString alloc] initWithString: @"This is a String!"];

    NSDictionary *plist = [unstyled RTFKitPropertyListRepresentation];
    
    STAssertEqualObjects(plist[RKPersistencyStringContentKey], @"This is a String!", @"String not properly serialized");
    STAssertEquals([plist[RKPersistencyAttributeRangesKey] count], 0UL, @"No attribute ranges expected");

    STAssertEquals([plist[RKPersistencyContextKey][RKPersistencyContextFileWrappersPersistencyKey] count], 0UL, @"No context data expected");
    STAssertEquals([plist[RKPersistencyContextKey][RKPersistencyContextListStylesPersistencyKey] count], 0UL, @"No context data expected");

    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(unstyled, reparsed, @"Error in serialization");
}

- (void)testPersistingSimpleStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range
    [original addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica-BoldOblique" size:32] range:NSMakeRange(1,2)];
    [original addAttribute:NSBackgroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.1 green:0.2 blue:0.3 alpha:0.4] range:NSMakeRange(1,2)];

    // Different range
    [original addAttribute:NSUnderlineStyleAttributeName value:@(2) range:NSMakeRange(3,3)];
    [original addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(3,3)];
    [original addAttribute:NSStrokeWidthAttributeName value:@(1) range:NSMakeRange(3,3)];
        
    [original addAttribute:NSBackgroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.1 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:0.2 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:NSUnderlineColorAttributeName value:[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:NSStrikethroughColorAttributeName value:[NSColor colorWithCalibratedRed:0.4 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    [original addAttribute:NSStrokeColorAttributeName value:[NSColor colorWithCalibratedRed:0.5 green:0.3 blue:0.2 alpha:0.1] range:NSMakeRange(3,1)];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowBlurRadius = 4.0f;
    shadow.shadowColor = [NSColor colorWithCalibratedRed:0.6 green:0.3 blue:0.2 alpha:0.1];
    shadow.shadowOffset = NSMakeSize(33.0f, 55.0f);
    
    [original addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(3,5)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

- (void)testPersistingEmptyParagraphStyles
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"Paragraph A\nParagraph B\nParagraph C\n"];
    
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    
    STAssertEqualObjects(plist[RKPersistencyStringContentKey], @"Paragraph A\nParagraph B\nParagraph C\n", @"String not properly serialized");
    STAssertEquals([plist[RKPersistencyAttributeRangesKey] count], 0UL, @"No attribute ranges expected");
    
    STAssertEquals([plist[RKPersistencyContextKey][RKPersistencyContextFileWrappersPersistencyKey] count], 0UL, @"No context data expected");
    STAssertEquals([plist[RKPersistencyContextKey][RKPersistencyContextListStylesPersistencyKey] count], 0UL, @"No context data expected");
    
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Error in serialization");
}

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

- (void)testAttachments
{
    NSFileWrapper *file = [[NSFileWrapper alloc] initRegularFileWithContents: [@"abc" dataUsingEncoding: NSUTF8StringEncoding]];
    file.filename = @"someFile";

    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.fileWrapper = file;
    
    NSAttributedString *original = [NSAttributedString attributedStringWithAttachment:attachment];

    // Test re-reading (an immediate comparison is not possible, since attachments cannot be compared directly)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original.string, reparsed.string, @"Error in serialization");
    
    NSTextAttachment *reparsedAttachment = [reparsed attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:NULL];
    NSFileWrapper *reparsedFile = reparsedAttachment.fileWrapper;
    
    STAssertFalse(attachment == reparsedAttachment, @"Attachment should not be equal!");
    STAssertFalse(file == reparsedFile, @"Attachment should not be equal!");
    
    STAssertEqualObjects(reparsedFile.filename, file.filename, @"Filenames should be equal");
    STAssertEqualObjects(reparsedFile.regularFileContents, file.regularFileContents, @"File contents should be equal");
}

- (void)testLinks
{
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range: NSURL
    [original addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://the-soulmen.com/"] range:NSMakeRange(1,2)];
    
    // Different range: NSString
    [original addAttribute:NSLinkAttributeName value:@"http://www.the-soulmen.com/" range:NSMakeRange(3,3)];
    
    // Test re-reading (direct comparison fails, since the NSString is re-parsed as NSURL)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];

    NSURL *firstURL = [reparsed attribute:NSLinkAttributeName atIndex:1 effectiveRange:NULL];
    NSURL *secondURL = [reparsed attribute:NSLinkAttributeName atIndex:3 effectiveRange:NULL];
    
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
    
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.fileWrapper = file;
    
    NSAttributedString *footnote = [NSAttributedString attributedStringWithAttachment:attachment];

    // Build container
    NSAttributedString *original = [NSAttributedString attributedStringWithFootnote: footnote];
    
    // Test re-reading (an immediate comparison is not possible, since attachments cannot be compared directly)
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    STAssertEqualObjects(original.string, reparsed.string, @"Error in serialization");
    
    NSAttributedString *reparsedFootnote = [reparsed attribute:RKFootnoteAttributeName atIndex:0 effectiveRange:NULL];
    
    NSTextAttachment *reparsedAttachment = [reparsedFootnote attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:NULL];
    NSFileWrapper *reparsedFile = reparsedAttachment.fileWrapper;
    
    STAssertFalse(attachment == reparsedAttachment, @"Attachment should not be equal!");
    STAssertFalse(file == reparsedFile, @"Attachment should not be equal!");
    
    STAssertEqualObjects(reparsedFile.filename, file.filename, @"Filenames should be equal");
    STAssertEqualObjects(reparsedFile.regularFileContents, file.regularFileContents, @"File contents should be equal");
}

- (void)testListStyles
{
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%a.", nil] 
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
    
    NSAttributedString *originalString = [NSAttributedString attributedStringWithListItem:[[NSAttributedString alloc] initWithString:@"A\n"] usingStyle:textList withIndentationLevel:2];

    // Test re-reading (an immediate comparison is not possible, so we compare the items)
    NSDictionary *plist = [originalString RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];

    RKListItem *originalItem = [originalString attribute:RKTextListItemAttributeName atIndex:0 effectiveRange:NULL];
    RKListItem *reparsedItem = [reparsed attribute:RKTextListItemAttributeName atIndex:0 effectiveRange:NULL];
    
    STAssertFalse(originalItem == reparsedItem, @"Items must not be identical");
    
    STAssertEqualObjects(originalItem, reparsedItem, @"Items must be equal");
}

- (void)testUserDefinedNumericAttribute
{
    [NSAttributedString registerNumericAttributeForPersistency:@"myNumericAttribute"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range: NSURL
    [original addAttribute:@"myNumericAttribute" value:@(123) range:NSMakeRange(1,2)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Not correctly persisted.");
}

- (void)testUserDefinedStringAttribute
{
    [NSAttributedString registerStringAttributeForPersistency:@"myStringAttribute"];
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString: @"This is a String!"];
    
    // First range: NSURL
    [original addAttribute:@"myStringAttribute" value:@"xyz" range:NSMakeRange(1,2)];
    
    // Test re-reading
    NSDictionary *plist = [original RTFKitPropertyListRepresentation];
    NSAttributedString *reparsed = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:plist error:NULL];
    
    STAssertEqualObjects(original, reparsed, @"Not correctly persisted.");
}

@end
