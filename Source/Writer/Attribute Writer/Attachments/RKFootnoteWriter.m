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
        NSString *noteTag = ([attributeName isEqual: RKEndnoteAttributeName] ) ? @"footnote\\ftnalt" : @"footnote";
		noteTag = [noteTag stringByAppendingFormat: @" \\tab{%@\\chftn }\\tab", [RKAttributedStringWriter stylesheetTagsFromAttributes:resources.document.footnoteAreaAnchorAttributes resources:resources]];

		// Adjust tabulators
		NSMutableAttributedString *fixedFootnote = [footnote mutableCopy];
		[fixedFootnote.mutableString replaceOccurrencesOfString:@"\n" withString:@"\n\t\t" options:0 range:NSMakeRange(0, fixedFootnote.length)];
		
		NSTextAlignment anchorAlignment = resources.document.footnoteAreaAnchorAlignment;
		CGFloat anchorInset = resources.document.footnoteAreaAnchorInset;
		CGFloat contentInset = resources.document.footnoteAreaContentInset;
				
		[fixedFootnote enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, fixedFootnote.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSParagraphStyle *currentParagraphStyle, NSRange range, BOOL *stop) {
			NSMutableParagraphStyle *mutableParagraphStyle = [currentParagraphStyle mutableCopy] ?: [NSMutableParagraphStyle new];
			mutableParagraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:anchorAlignment location:anchorInset options:nil], [[NSTextTab alloc] initWithTextAlignment:NSNaturalTextAlignment location:contentInset options:nil]];
			
			[fixedFootnote addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle range:range];
		}];
		
		// Convert footnote
        NSString *noteContent = [NSString stringWithRTFGroupTag:noteTag body:[RKAttributedStringWriter RTFFromAttributedString:fixedFootnote withConversionPolicy:RKConversionPolicySkippingAttachments(conversionPolicy) resources:resources]];
        
        // Footnote marker
        [taggedString registerTag:@"{\\chftn }" forPosition:range.location];
        
        // Footnote content
        [taggedString registerTag:noteContent forPosition:range.location];
                
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
