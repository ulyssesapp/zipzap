//
//  RKAttributedStringWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKAttributedStringWriter.h"

@interface RKAttributedStringWriter ()

/*!
 @abstract Converts an attributed string to a tagged string
 */
+ (RKTaggedString *)taggedStringFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

/*!
 @abstract Adds tags for all paragraph styles
 */
+ (void)tagParagraphStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString;

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tagFontStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString resources:resources;

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tagAttachmentStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:attachmentPolicy resources:resources;

/*!
 @abstract Converts a paragraph style to RTF
 */
+ (NSString *)RTFfromParagraphStyle:(NSParagraphStyle *)paragraphStyle;

@end

@implementation RKAttributedStringWriter

+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [self taggedStringFromAttributedString:attributedString withAttachmentPolicy:attachmentPolicy resources:resources];
    NSString *attachmentCharracterString = [NSString stringWithFormat:@"%C", NSAttachmentCharacter];

    
    // Return the tagged string and remove all useless attachment charracters
    return [[taggedString flattenedString] stringByReplacingOccurrencesOfString:attachmentCharracterString withString:@"" ];
}

+ (RKTaggedString *)taggedStringFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];

    // Adds paragraphs, fonts and text attachment. 
    // These operations are ordered by the placement priority of the generated tags in the RTF file. 
    [self tagParagraphStyles:taggedString fromAttributedString:attributedString];
    [self tagFontStyles:taggedString fromAttributedString:attributedString resources:resources];
    [self tagAttachmentStyles:taggedString fromAttributedString:attributedString withAttachmentPolicy:attachmentPolicy resources:resources];
    
    return taggedString;
}


/*!
 @abstract Adds tags for all paragraph styles
 */
+ (void)tagParagraphStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString
{
    
}

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tagFontStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString resources:resources
{
    
}

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tagAttachmentStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:attachmentPolicy resources:resources
{
    
}

+ (NSString *)RTFfromParagraphStyle:(NSParagraphStyle *)paragraphStyle
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
