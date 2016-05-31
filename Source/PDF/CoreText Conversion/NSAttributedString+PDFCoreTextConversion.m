//
//  NSAttributedString+PDFCoreTextConversion.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFCoreTextConversion.h"

#import "RKAttributedStringWriter.h"
#import "RKCoreTextRepresentationConverter.h"
#import "RKPDFRenderingContext.h"
#import "NSAttributedString+PDFUtilities.h"

#import "NSString+Hyphenation.h"

@implementation NSAttributedString (PDFCoreTextConversion)

NSMutableArray *NSAttributedStringCoreTextConverters;

+ (void)registerConverter:(Class)converter
{
    NSParameterAssert([converter isSubclassOfClass: RKCoreTextRepresentationConverter.class]);
    
    if (!NSAttributedStringCoreTextConverters)
        NSAttributedStringCoreTextConverters = [NSMutableArray new];
    
    [NSAttributedStringCoreTextConverters addObject: converter];
}

- (NSAttributedString *)coreTextRepresentationUsingContext:(RKPDFRenderingContext *)context
{
    // Preprocess styles as it is done for RTF output
    NSAttributedString *convertedString = [RKAttributedStringWriter attributedStringByAdjustingStyles:self usingPreprocessingPolicy:RKAttributePreprocessorListMarkerPositionsUsingIndent];
    
    // Convert styles to CoreText representation
    for (Class converter in NSAttributedStringCoreTextConverters) {
        convertedString = [converter coreTextRepresentationForAttributedString:convertedString usingContext:context];
    }
    
	// Apply hyphenation, if requested
	if (context.document.hyphenationEnabled && context.document.locale.supportsHyphenation) {
		NSMutableAttributedString *hyphenatedString = [convertedString mutableCopy];
		
		__block NSString *lastHyphentationCharacter;
		__block NSInteger lastHyphenationRangeStart = 0;
		
		// Only hyphenate if supported by paragraph
		[hyphenatedString enumerateAttribute:RKAdditionalParagraphStyleAttributeName inRange:NSMakeRange(0, hyphenatedString.length) options:0 usingBlock:^(RKAdditionalParagraphStyle *paragraphStyle, NSRange range, BOOL *stop) {
			// Skip paragraphs that should not be hyphenated
			if (!paragraphStyle.hyphenationEnabled)
				return;
			
			// Detect hyphenations
			[hyphenatedString.mutableString enumerateHyphenationsInRange:range usingLocale:context.document.locale block:^(NSUInteger index, NSString *suggestedSeparator) {
				// Add soft-hyphenation as hint for Core Text
				[hyphenatedString.mutableString insertString:@"\u00ad" atIndex:index];
				
				// Remember the suggested hyphenation char for the given locale as attribute. Try to create large attribute ranges, to reduce the number of runs for typesetting.
				if (![lastHyphentationCharacter isEqualToString: suggestedSeparator]) {
					if (lastHyphentationCharacter)
						[hyphenatedString addAttribute:RKHyphenationCharacterAttributeName value:lastHyphentationCharacter range:NSMakeRange(lastHyphenationRangeStart, index - lastHyphenationRangeStart)];
					
					lastHyphentationCharacter = suggestedSeparator;
					lastHyphenationRangeStart = index;
				}
			}];
		}];

		// Setup hyphenation attribute for remaining range
		if (lastHyphentationCharacter)
			[hyphenatedString addAttribute:RKHyphenationCharacterAttributeName value:lastHyphentationCharacter range:NSMakeRange(lastHyphenationRangeStart, hyphenatedString.length - lastHyphenationRangeStart)];
		
		convertedString = hyphenatedString;
	}
	
    return convertedString;
}

@end
