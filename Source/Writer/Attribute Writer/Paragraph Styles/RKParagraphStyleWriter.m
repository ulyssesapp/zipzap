//
//  RKParagraphStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKParagraphStyleWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"
#import "RKAttributedStringAdditions.h"

@interface RKParagraphStyleWriter ()

/*!
 @abstract Generates the required tags for styling a paragraph
 */
+ (NSString *)styleTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range;

/*!
 @abstract Generates the required opening tags for setting a new paragraph style
 */
+ (NSString *)openingTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range;

@end

@implementation RKParagraphStyleWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSParagraphStyleAttributeName priority:RKAttributedStringWriterPriorityParagraphLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSParagraphStyle *)paragraphStyle
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSString *paragraphHeader = [self openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:range];

    [taggedString registerTag:paragraphHeader forPosition:range.location];
    [taggedString registerClosingTag:@"\\par\n" forPosition:NSMaxRange(range)];
    
    // Remove terminating newline, since Cocoa will add automatically a newline on the end of a paragraph
    if ([[[attributedString string] substringWithRange:range] hasSuffix:@"\n"]) {
        [taggedString removeRange:NSMakeRange(NSMaxRange(range) - 1, 1)];
    }
}

+ (NSString *)openingTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range
{
    return [NSString stringWithFormat:@"\\pard%@", [self styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:range]];
}
    
+ (NSString *)styleTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range
{
    NSMutableString *rtf = [NSMutableString new];
    
    // Writing directiong
    if (paragraphStyle.baseWritingDirection == NSWritingDirectionRightToLeft)
        [rtf appendString:@"\\rtlpar"];
    
    // Alignment
    switch (paragraphStyle.alignment) {
        case NSLeftTextAlignment:
            [rtf appendString:@"\\ql"];
            break;
            
        case NSRightTextAlignment:
            [rtf appendString:@"\\qr"];
            break;
            
        case NSCenterTextAlignment:
            [rtf appendString:@"\\qc"];
            break;
            
        case NSJustifiedTextAlignment:
            [rtf appendString:@"\\qj"];
            break;            
    }
    
    // Indentation
    if (paragraphStyle.firstLineHeadIndent != 0)
        [rtf appendFormat:@"\\fi%i\\cufi%i", 
         (NSUInteger)RKPointsToTwips(paragraphStyle.firstLineHeadIndent - paragraphStyle.headIndent), 
         (NSUInteger)RKPointsToTwips(paragraphStyle.firstLineHeadIndent - paragraphStyle.headIndent)
        ];
    
    if (paragraphStyle.headIndent != 0)
        [rtf appendFormat:@"\\li%u\\culi%u", (NSUInteger)RKPointsToTwips(paragraphStyle.headIndent), (NSUInteger)RKPointsToTwips(paragraphStyle.headIndent)];
    
    // FIXME: It is not clear, how Cocoa calculates this
    if (paragraphStyle.tailIndent != 0)
        [rtf appendFormat:@"\\ri%i", (NSInteger)RKPointsToTwips(fabs(paragraphStyle.tailIndent))];
    
    // Line spacing
    if (paragraphStyle.lineSpacing != 0)
        [rtf appendFormat:@"\\slleading%u", (NSUInteger)RKPointsToTwips(paragraphStyle.lineSpacing), (NSUInteger)RKPointsToTwips(paragraphStyle.lineSpacing)];
    
    if (paragraphStyle.lineHeightMultiple != 0) {
        CGFloat calculatedLineHeight = [attributedString pointSizeInRange:range] * paragraphStyle.lineHeightMultiple;
        
        [rtf appendFormat:@"\\sl%u\\slmult1", (NSUInteger)RKPointsToTwips(calculatedLineHeight), (NSUInteger)paragraphStyle.lineHeightMultiple];
    }
        
    if (paragraphStyle.maximumLineHeight != 0)
        [rtf appendFormat:@"\\slmaximum%u", (NSUInteger)RKPointsToTwips(paragraphStyle.maximumLineHeight)];
    
    if (paragraphStyle.minimumLineHeight != 0)
        [rtf appendFormat:@"\\slminimum%u", (NSUInteger)RKPointsToTwips(paragraphStyle.minimumLineHeight)];
    
    // Paragraph spacing
    if (paragraphStyle.paragraphSpacingBefore != 0)
        [rtf appendFormat:@"\\sb%u", (NSUInteger)RKPointsToTwips(paragraphStyle.paragraphSpacingBefore)];
    
    if (paragraphStyle.paragraphSpacing != 0)
        [rtf appendFormat:@"\\sa%u", (NSUInteger)RKPointsToTwips(paragraphStyle.paragraphSpacing)];
    
    // Default tab interval
    // (While the Cocoa reference says this defaults to "0", it seems to default to "36" - so we will be explicit here)
    [rtf appendFormat:@"\\pardeftab%u", (NSUInteger)RKPointsToTwips(paragraphStyle.defaultTabInterval)];
    
    // Translation of tab stops
    for (NSTextTab *tabStop in paragraphStyle.tabStops) {
        switch (tabStop.tabStopType) {
            case NSCenterTabStopType:
                [rtf appendString:@"\\tqc"];
                break;
                
            case NSRightTabStopType:
                [rtf appendString:@"\\tqr"];
                break;
                
            case NSDecimalTabStopType:
                [rtf appendString:@"\\tqdec"];
                break;
        }
        
        [rtf appendFormat:@"\\tx%u", (NSUInteger)RKPointsToTwips(tabStop.location)];
    }
    
    // To prevent conflicts with succeeding text, we add a space
    [rtf appendString:@" "];
    
    return rtf;
}

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(NSParagraphStyle *)paragraphStyle
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources
{
    // If no paragraph style is given, no defaults should appear in a style sheet
    if (!paragraphStyle)    
        return @"";

    // To calculate the line height attribute in a style sheet, all RTF writers seem to use the line height of the style setting rather than the line height of the actual paragraph
    NSAttributedString *simulatedParagraph = [[NSAttributedString alloc] initWithString:@"A\n" attributes:styleSetting ];
    
    return [self styleTagFromParagraphStyle:paragraphStyle ofAttributedString:simulatedParagraph inRange:NSMakeRange(0, 2)];
}

@end
