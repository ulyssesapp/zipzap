//
//  RKPredefinedStyleAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPredefinedStyleAttributeWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKPredefinedStyleAttributeWriter

+ (void)load {
    [RKAttributedStringWriter registerWriter:self forAttribute:RKPredefinedParagraphStyleAttributeName priority:RKAttributedStringWriterPriorityParagraphStylingLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:RKPredefinedCharacterStyleAttributeName priority:RKAttributedStringWriterPriorityInlineStylesheetLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSString *)styleName
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;
{
    if (!styleName)
        return;

    // Attribute specific settings
    NSUInteger styleIndex;
    NSString *styleTypeTag;
    
    if ([attributeName isEqualTo: RKPredefinedParagraphStyleAttributeName]) {
        styleIndex = [resources indexOfParagraphStyle: styleName];
        styleTypeTag = @"\\s";
    }
    else if ([attributeName isEqualTo: RKPredefinedCharacterStyleAttributeName]) {
        styleIndex = [resources indexOfCharacterStyle: styleName];        
        styleTypeTag = @"\\*\\cs";
    }

    // We just ignore the default style or unknown styles, because stylesheets must be inside {blocks} and automatically default
    if (styleIndex == 0)
        return;
    
    // Register style
    NSString *openingTag = [NSString stringWithFormat:@"{%@%u ", styleTypeTag, styleIndex];

    [taggedString registerTag:openingTag forPosition:range.location];
    [taggedString registerTag:@"}" forPosition:range.location + range.length];
}

@end
