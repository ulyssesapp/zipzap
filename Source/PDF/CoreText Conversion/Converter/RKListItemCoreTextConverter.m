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
#import "RKParagraphStyleWrapper.h"

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
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[attributedString enumerateAttribute:RKListItemAttributeName inRange:substringRange options:0 usingBlock:^(RKListItem *listItem, NSRange range, BOOL *stop) {
			if (!listItem)
				return;
		   
			// Prepare attributes for list marker
			NSDictionary *currentAttributes = [attributedString attributesAtIndex:range.location effectiveRange:nil];
			NSMutableDictionary *listMarkerAttributes = [[listItem.listStyle markerStyleForLevel: listItem.indentationLevel] mutableCopy] ?: [NSMutableDictionary new];

			// Do not insert marker string if item has been already used by another paragraph.
			NSString *markerString;
			if (![context consumeListItem: listItem])
				markerString = [NSString stringWithFormat:@"%@\t", [context.listCounter markerForListItem: listItem]];
			else
				markerString = @"\t";
			
			// Insert marker string (include a tab behave the same as the cocoa text engine)
			NSAttributedString *styledMarkerString = [[NSAttributedString alloc] initWithString:markerString attributes:listMarkerAttributes];
			__block NSRange fixRange = NSMakeRange(range.location + insertionOffset, range.length + markerString.length);
			
			[converted insertAttributedString:styledMarkerString atIndex:range.location + insertionOffset];
			[converted addAttribute:NSParagraphStyleAttributeName value:currentAttributes[NSParagraphStyleAttributeName] range:fixRange];
			[converted addAttribute:RKAdditionalParagraphStyleAttributeName value:currentAttributes[RKAdditionalParagraphStyleAttributeName] range:fixRange];

			insertionOffset += markerString.length;
			
			// Remove text list item attribute
			[converted removeAttribute:RKListItemAttributeName range:fixRange];
		}];
	}];
		
    return converted;
}

@end