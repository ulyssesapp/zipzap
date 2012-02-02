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

@interface RKParagraphStyleWriter ()

/*!
 @abstract Generates the required opening tags for a paragraph style
 */
+ (NSString *)openingTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle;

/*!
 @abstract Generates the required formatting information for a text list
 */
+ (NSString *)openingTagsForTextLists:(NSArray *)textLists
                  ofAttributedString:(NSAttributedString *)attributedString 
                             inRange:(NSRange)range 
                           resources:(RKResourcePool *)resources;

@end

@implementation RKParagraphStyleWriter

+ (void)addTagsForAttributedString:(NSAttributedString *)attributedString
             toTaggedString:(RKTaggedString *)taggedString 
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
     [attributedString enumerateAttribute:NSParagraphStyleAttributeName 
                                  inRange:NSMakeRange(0, [attributedString length])
                                  options:0 
                               usingBlock:^(NSParagraphStyle *paragraphStyle, NSRange range, BOOL *stop) 
    {
         NSString *paragraphHeader = [self openingTagFromParagraphStyle:paragraphStyle];
         NSString *listHeader = [self openingTagsForTextLists:paragraphStyle.textLists ofAttributedString:attributedString inRange:range resources:resources];

         [taggedString registerTag:paragraphHeader forPosition:range.location];
         [taggedString registerTag:listHeader forPosition:range.location];
         [taggedString registerTag:@"\\par\n" forPosition:(range.location + range.length)];
     }];
}

+ (NSString *)openingTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
    NSMutableString *rtf = [NSMutableString stringWithString:@"\\pard"];
    
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
        [rtf appendFormat:@"\\fl%i", (NSInteger)RKPointsToTwips(paragraphStyle.firstLineHeadIndent)];
    
    if (paragraphStyle.headIndent != 0)
        [rtf appendFormat:@"\\culi%i", (NSInteger)RKPointsToTwips(paragraphStyle.headIndent)];
    
    if (paragraphStyle.tailIndent != 0)
        [rtf appendFormat:@"\\ri%i", (NSInteger)RKPointsToTwips(paragraphStyle.tailIndent)];
    
    // Line spacing
    if (paragraphStyle.lineSpacing != 0)
        [rtf appendFormat:@"\\sl%u", (NSUInteger)RKPointsToTwips(paragraphStyle.lineSpacing)];
    
    if (paragraphStyle.lineHeightMultiple != 0)
        [rtf appendFormat:@"\\slmult%u", (NSUInteger)paragraphStyle.lineHeightMultiple];
    
    if (paragraphStyle.maximumLineHeight != 0)
        [rtf appendFormat:@"\\slmaximum%u", (NSUInteger)RKPointsToTwips(paragraphStyle.maximumLineHeight)];
    
    if (paragraphStyle.minimumLineHeight != 0)
        [rtf appendFormat:@"\\slminimum%u", (NSUInteger)RKPointsToTwips(paragraphStyle.minimumLineHeight)];
    
    // Paragraph spacing
    if (paragraphStyle.paragraphSpacingBefore != 0)
        [rtf appendFormat:@"\\sb%u", (NSUInteger)RKPointsToTwips(paragraphStyle.paragraphSpacingBefore)];
    
    if (paragraphStyle.paragraphSpacing != 0)
        [rtf appendFormat:@"\\sa%u", (NSUInteger)RKPointsToTwips(paragraphStyle.paragraphSpacing)];
    
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

+ (NSString *)openingTagsForTextLists:(NSArray *)textLists
                   ofAttributedString:(NSAttributedString *)attributedString 
                              inRange:(NSRange)range 
                            resources:(RKResourcePool *)resources;
{
    return @"";
}

@end
