//
//  RKParagraphStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyleWriter.h"
#import "RKTaggedString.h"

@interface RKParagraphStyleWriter ()

/*!
 @abstract Generates the required opening tags for a paragraph style
 */
+ (NSString *)RTFOpeningTagfromParagraphStyle:(NSParagraphStyle *)paragraphStyle;

@end

@implementation RKParagraphStyleWriter

+ (void)tag:(RKTaggedString *)taggedString withParagraphStylesOfAttributedString:(NSAttributedString *)attributedString
{
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, [attributedString length]) 
                                 options:0 
                              usingBlock:
     ^(NSParagraphStyle *paragraphStyle, NSRange range, BOOL *stop) {
         if (paragraphStyle) {
             NSString *paragraphHeader = [self RTFOpeningTagfromParagraphStyle:paragraphStyle];

             [taggedString associateTag:paragraphHeader atPosition:range.location];
             [taggedString associateTag:@"\\par\n" atPosition:(range.location + range.length)];
         }
    }];
}

+ (NSString *)RTFOpeningTagfromParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
    NSMutableString *rtf = [NSMutableString stringWithString:@"\\pard"];
    
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
    if (paragraphStyle.firstLineHeadIndent != .0)
        [rtf appendFormat:@"\\fl%i", (NSInteger)RKPointsToTwips(paragraphStyle.firstLineHeadIndent)];
    
    if (paragraphStyle.headIndent != .0)
        [rtf appendFormat:@"\\culi%i", (NSInteger)RKPointsToTwips(paragraphStyle.headIndent)];
    
    if (paragraphStyle.tailIndent != .0)
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
    [paragraphStyle.tabStops enumerateObjectsUsingBlock:^(NSTextTab *tabStop, NSUInteger idx, BOOL *stop) {
        switch (tabStop.tabStopType) {
            case NSCenterTabStopType:
                [rtf appendFormat:@"\\tqc"];
                break;
                
            case NSRightTabStopType:
                [rtf appendFormat:@"\\tqr"];
                break;
                
            case NSDecimalTabStopType:
                [rtf appendFormat:@"\\tqdec"];
                break;
        }
        
        [rtf appendFormat:@"\\tx%u", (NSUInteger)RKPointsToTwips(tabStop.location)];
    }];
    
    // To prevent conflicts with succeeding text, we add a space
    [rtf appendFormat:@" "];
    
    return rtf;
}

@end
