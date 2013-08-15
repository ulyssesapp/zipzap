//
//  RKFootnoteWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnoteWriter.h"
#import "RKAttributedStringWriter.h"
#import "NSString+RKConvenienceAdditions.h"

@implementation RKFootnoteWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKFootnoteAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKEndnoteAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
    }
}
    
+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSAttributedString *)footnote
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
    if (footnote) {
        NSString *noteTag = ([attributeName isEqual: RKEndnoteAttributeName] ) ? @"footnote\\ftnalt {\\super \\chftn }" : @"footnote {\\super \\chftn }";
                
        NSString *noteContent = [NSString stringWithRTFGroupTag:noteTag body:[RKAttributedStringWriter RTFFromAttributedString:footnote withConversionPolicy:RKConversionPolicySkippingAttachments(conversionPolicy) resources:resources]];
        
        // Footnote marker
        [taggedString registerTag:@"{\\super \\chftn }" forPosition:range.location];
        
        // Footnote content
        [taggedString registerTag:noteContent forPosition:range.location];
                
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
