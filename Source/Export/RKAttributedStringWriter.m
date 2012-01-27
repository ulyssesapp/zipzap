//
//  RKAttributedStringWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKAttributedStringWriter.h"

#import "RKParagraphStyleWriter.h"
#import "RKFontStyleWriter.h"
#import "RKLinkWriter.h"
#import "RKTextAttachmentWriter.h"

@interface RKAttributedStringWriter ()

/*!
 @abstract Converts an attributed string to a tagged string
 */
+ (RKTaggedString *)taggedStringFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end

@implementation RKAttributedStringWriter

+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [self taggedStringFromAttributedString:attributedString withAttachmentPolicy:attachmentPolicy resources:resources];
    NSString *attachmentCharracterString = [NSString stringWithFormat:@"%C", NSAttachmentCharacter];
    
    // Return the tagged string and remove all useless attachment charracters
    return [[taggedString flattenedRTFString] stringByReplacingOccurrencesOfString:attachmentCharracterString withString:@"" ];
}

+ (RKTaggedString *)taggedStringFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];

    // Adds paragraphs, fonts and text attachment. 
    // These operations are ordered by the placement priority of the generated tags in the RTF file. 
    [RKParagraphStyleWriter tag:taggedString withParagraphStylesOfAttributedString:attributedString];

    [RKFontStyleWriter tag:taggedString withFontStylesOfAttributedString:attributedString resources:resources];

    [RKLinkWriter tag:taggedString withLinkStylesOfAttributedString:attributedString];

    [RKTextAttachmentWriter tag:taggedString withTextAttachmentsOfAttributedString:attributedString withAttachmentPolicy:attachmentPolicy resources:resources];
    
    return taggedString;
}

@end
