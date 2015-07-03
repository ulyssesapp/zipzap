	//
//  RKParagraphStylePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "RKParagraphStyleCoreTextConverter.h"
#import "RKParagraphStyleWrapper.h"

#import "RKListCounter.h"
#import "RKListItem.h"
#import "RKListStyle.h"

@implementation RKParagraphStyleCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
	RKListCounter *listCounter = [RKListCounter new];
	NSMutableSet *visitedListItems = [NSMutableSet new];
	
	NSMutableAttributedString *converted = [attributedString mutableCopy];
	__block NSUInteger insertionOffset = 0;
	
	[attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSParagraphStyle *nsParagraphStyle, NSRange paragraphStyleRange, BOOL *stop) {

		// Enumerate over all text paragraphs in order to generate list item markers
		[attributedString.string enumerateSubstringsInRange:paragraphStyleRange options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substsringRange, NSRange enclosingRange, BOOL *stop) {
			NSRange convertedRange = NSMakeRange(enclosingRange.location + insertionOffset, enclosingRange.length);
			
			// Get NSParagraphStyle for conversion to CoreText paragraph style
			RKParagraphStyleWrapper *wrappedParagraphStyle = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: nsParagraphStyle];
			
			// Insert list marker and update paragraph style for lists
			RKListItem *listItem = [attributedString attribute:RKListItemAttributeName atIndex:enclosingRange.location effectiveRange:NULL];
			
			if (listItem) {
				NSString *markerString;
				
				// Mix marker attributes with current string attributes
				NSMutableDictionary *listMarkerAttributes = [[attributedString attributesAtIndex:enclosingRange.location effectiveRange:NULL] mutableCopy] ?: [NSMutableDictionary new];
				[listMarkerAttributes addEntriesFromDictionary: [listItem.listStyle markerStyleForLevel: listItem.indentationLevel] ?: @{}];
				
				// Insert marker string only on the fist paragraph of a list item
				if (![visitedListItems containsObject: listItem]) {
					markerString = [NSString stringWithFormat:@"%@\t", [listCounter markerForListItem: listItem]];
					[visitedListItems addObject: listItem];
				}
				
				// Second items: Do not insert marker, but increase paragraph indentation
				else {
					markerString = @"";
					wrappedParagraphStyle.firstLineHeadIndent = [listMarkerAttributes[RKListStyleMarkerLocationKey] floatValue] + [listMarkerAttributes[RKListStyleMarkerWidthKey] floatValue];
				}
				
				// Insert marker string (include a tab behave the same as the cocoa text engine)
				NSAttributedString *styledMarkerString = [[NSAttributedString alloc] initWithString:markerString attributes:listMarkerAttributes];
				convertedRange = NSMakeRange(enclosingRange.location + insertionOffset, enclosingRange.length + markerString.length);
				
				[converted insertAttributedString:styledMarkerString atIndex:enclosingRange.location + insertionOffset];
				
				insertionOffset += markerString.length;
			}
			
			// Convert paragraph style
			[converted removeAttribute:NSParagraphStyleAttributeName range:convertedRange];
			[converted addAttribute:(id)kCTParagraphStyleAttributeName value:(id)[wrappedParagraphStyle newCTParagraphStyle] range:convertedRange];
		}];
	}];
	
	return converted;
}

@end
