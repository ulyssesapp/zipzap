//
//  RKTextListItemWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItemWriter.h"
#import "RKAttributedStringWriter.h"
#import "RKListItem.h"
#import "RKListStyle+WriterAdditions.h"
#import "RKConversion.h"
#import "RKParagraphStyleWrapper.h"
#import "RKTextTabWrapper.h"

#import "NSMutableAttributedString+ParagraphStyleWrapper.h"

@implementation RKListItemWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKListItemAttributeName priority:RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel];
    }
}

+ (void)preprocessAttribute:(NSString *)attributeName
                      value:(RKListItem *)listItem
             effectiveRange:(NSRange)range
         ofAttributedString:(NSMutableAttributedString *)preprocessedString
				usingPolicy:(RKAttributePreprocessingPolicy)policy
{
    if (!listItem)
        return;
    
    // Get paragraph style of list item
    RKListStyle *listStyle = listItem.listStyle;

	NSDictionary *markerStyle = [listStyle markerStyleForLevel: listItem.indentationLevel];
	CGFloat enumeratorLocation = [markerStyle[RKListStyleMarkerLocationKey] floatValue];
	CGFloat relativeTextLocation = [markerStyle[RKListStyleMarkerWidthKey] floatValue];
	CGFloat textLocation = relativeTextLocation + enumeratorLocation;
	__block NSUInteger paragraphIndex = 0;
	
	enumeratorLocation = round(enumeratorLocation * 0.5) / 0.5;
	textLocation = round(textLocation * 0.5) / 0.5;
	
	// Update paragraph style, so tabulators will be used for enumerator positioning (TextEdit)
	[preprocessedString updateParagraphStylesInRange:range usingBlock:^(NSRange paragraphRange, RKParagraphStyleWrapper *paragraphStyle) {
		// Set indentation (word export needs additional head indent set to the enumerator's position)
		if (policy & RKAttributePreprocessorListMarkerPositionsUsingIndent)
			paragraphStyle.firstLineHeadIndent = enumeratorLocation;
		else if (paragraphIndex)
			// Set first line head indent for nested items (PDF + System-RTF)
			paragraphStyle.firstLineHeadIndent = textLocation;
		else
			// Skip first line head indent on paragraph carrying an enumerator (PDF + System-RTF)
			paragraphStyle.firstLineHeadIndent = 0;
		
		paragraphStyle.headIndent = textLocation;
			
		// Setup new NSTextTabs instances for the given tabs stops
		NSMutableArray *newTabStops = [NSMutableArray new];
		[newTabStops addObject: [[RKTextTabWrapper alloc] initWithLocation:0 alignment:kCTTextAlignmentLeft]];
		[newTabStops addObject: [[RKTextTabWrapper alloc] initWithLocation:relativeTextLocation alignment:kCTTextAlignmentLeft]];

		// If there are already tab stops, take only tab stops at a higher location than the first text
		for (NSTextTab *tab in paragraphStyle.tabStops) {
			if (tab.location > textLocation)
				[newTabStops addObject: tab];
		}
				
		paragraphStyle.tabStops = newTabStops;
		
		paragraphIndex ++;
	}];
	
	if (range.length == 0)
		return;
	
	if (policy & RKAttributePreprocessorInnerListParagraphsUsingLineBreak) {
		// Pages-RTF requires that nested paragraphs are actually nested lines...
		RKParagraphStyleWrapper *lastParagraphStyle = [preprocessedString wrappedParagraphStyleAtIndex: NSMaxRange(range)-1];
		
		// Exchange paragraph breaks by newlines (required by RTF)
		[preprocessedString.mutableString replaceOccurrencesOfString:@"\n" withString:@"\u2028" options:0 range:NSMakeRange(range.location, range.length - 1)];

		// We need to unify the last and the first paragraph style, since we've exchanged paragraph breaks by newlines.
		[preprocessedString updateParagraphStylesInRange:range usingBlock:^(NSRange range, RKParagraphStyleWrapper *paragraphStyle) {
			paragraphStyle.paragraphSpacing = lastParagraphStyle.paragraphSpacing;
		}];
	}
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(RKListItem *)listItem
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
    if (listItem) {
        NSUInteger listIndex = [resources.listCounter indexOfListStyle: listItem.listStyle];
        NSArray *itemNumbers = [resources.listCounter incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.listStyle resetIndex:listItem.resetIndex];
        
        NSString *markerString = [RKListStyle systemCompatibleMarker: [[listItem.listStyle markerForItemNumbers:itemNumbers] RTFEscapedString]];
		NSString *markerStyle = [RKAttributedStringWriter stylesheetTagsFromAttributes:[listItem.listStyle markerStyleForLevel: listItem.indentationLevel] resources:resources];

        // Register the list marker
        [taggedString registerTag:[NSString stringWithFormat:@"\\ls%li\\ilvl%li {%@\\listtext%@}", listIndex, listItem.indentationLevel, markerStyle, markerString] forPosition:range.location];
		
		// For compatibility reasons we require each list item to terminate with a \par (otherwise Word inherits the paragraph style set at the paragraph break for the list marker)
		if ([attributedString.string characterAtIndex: NSMaxRange(range)-1] != '\n')
			[taggedString registerClosingTag:@"\\par\\pard" forPosition:NSMaxRange(range)];
    }
}

@end
