//
//  RKStyleNameAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStyleNameAttributeWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKStyleNameAttributeWriter

+ (void)load
{
    @autoreleasepool {
        // Paragraph styles and inline styles must have a higher priority in order to work with OpenOffice
        [RKAttributedStringWriter registerWriter:self forAttribute:RKParagraphStyleNameAttributeName priority:RKAttributedStringWriterPriorityParagraphStyleSheetLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKCharacterStyleNameAttributeName priority:RKAttributedStringWriterPriorityInlineStylesheetLevel];
    }
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(NSString *)styleName
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources;
{
    if (!styleName)
        return;

    // Attribute specific settings
    NSUInteger styleIndex;
    NSString *styleTypeOpeningTag;
    NSString *styleTypeClosingTag;
    
    if ([attributeName isEqual: RKParagraphStyleNameAttributeName]) {
        styleIndex = [resources indexOfParagraphStyle: styleName];
        styleTypeOpeningTag = @"\\s";
        styleTypeClosingTag = @"";
    }
    else if ([attributeName isEqual: RKCharacterStyleNameAttributeName]) {
        styleIndex = [resources indexOfCharacterStyle: styleName];        
        // Enclosing character styles into a control group is required by OpenOffice
        styleTypeOpeningTag = @"{\\cs";
        styleTypeClosingTag = @"}";
    }
    else {
        NSAssert(false, @"Invalid style attribute");
        return;
    }

    // We just ignore the default style or unknown styles, because:
    // - Character styles are inside {groups} and thus reset after the end of the group
    // - New paragraphs are introduced with the \pard command and thus use the default paragraph style automatically
    if (styleIndex == 0)
        return;
    
    // Register style
    NSString *openingTag = [NSString stringWithFormat:@"%@%lu ", styleTypeOpeningTag, styleIndex];

    [taggedString registerTag:openingTag forPosition:range.location];
    [taggedString registerClosingTag:styleTypeClosingTag forPosition:range.location + range.length];
}

@end
