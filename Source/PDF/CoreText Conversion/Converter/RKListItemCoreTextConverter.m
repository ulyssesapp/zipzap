//
//  RKListItemPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItemCoreTextConverter.h"
#import "RTFKit.h"
#import "RKListStyle+WriterAdditions.h"
#import "RKListCounter.h"
#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFCoreTextConversion.h"

@implementation RKListItemCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    __block NSUInteger insertionOffset = 0;
    
    [attributedString enumerateAttribute:RKTextListItemAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(RKListItem *listItem, NSRange range, BOOL *stop) {
        if (!listItem)
            return;
       
		// Prepare attributes for list marker
		NSDictionary *currentAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
		NSMutableDictionary *listMarkerAttributes = [[listItem.listStyle markerStyleForLevel: listItem.indentationLevel] mutableCopy] ?: [NSMutableDictionary new];
		
		if (currentAttributes[NSParagraphStyleAttributeName])
			listMarkerAttributes[NSParagraphStyleAttributeName] = currentAttributes[NSParagraphStyleAttributeName];
		if (currentAttributes[RKAdditionalParagraphStyleAttributeName])
			listMarkerAttributes[RKAdditionalParagraphStyleAttributeName] = currentAttributes[RKAdditionalParagraphStyleAttributeName];
		
        // Insert marker string (include a tab behave the same as the cocoa text engine)
        NSString *markerString = [NSString stringWithFormat:@"\t%@\t", [context.listCounter markerForListItem: listItem]];
        NSAttributedString *styledMarkerString = [[NSAttributedString alloc] initWithString:markerString attributes:listMarkerAttributes];
		__block NSRange fixRange = NSMakeRange(range.location + insertionOffset, range.length + markerString.length);
        
        [converted insertAttributedString:styledMarkerString atIndex:range.location + insertionOffset];
        insertionOffset += markerString.length;

		// Indent all nested paragraphs and lines
		NSMutableString *convertedString = converted.mutableString;
		[convertedString enumerateSubstringsInRange:fixRange options:NSStringEnumerationByParagraphs|NSStringEnumerationByLines|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
			// Do not indent first line
			if (enclosingRange.location == fixRange.location)
				return;
			
			[convertedString insertString:@"\t\t" atIndex:enclosingRange.location];
			insertionOffset += 2;
			fixRange.length += 2;
		}];
		
        // Remove text list item attribute
        [converted removeAttribute:RKTextListItemAttributeName range:fixRange];
    }];
    
    return converted;
}

@end
