//
//  RKSectionWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"
#import "RKWriter.h"
#import "RKResourcePool.h"
#import "RKSectionWriter.h"
#import "RKAttributedStringWriter.h"
#import "NSString+RKConvenienceAdditions.h"

@interface RKSectionWriter ()

/*!
 @abstract Translates all section attributes to RTF command
 */
+ (NSString *)sectionAttributesForSection:(RKSection *)section usingDocument:(RKDocument *)document;

/*!
 @abstract Translates a mapping from tag names to attributed string such that the translated
           attributed strings are surrounded by the given tag
 */
+ (NSString *)translateAttributedStringMap:(NSDictionary *)attributedStringMap
                      withConversionPolicy:(RKConversionPolicy)conversionPolicy 
                                 resources:(RKResourcePool *)resources;

/*!
 @abstract Translates all headers of a section to RTF
 */
+ (NSString *)headersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

/*!
 @abstract Translates all footers of a section to RTF
 */
+ (NSString *)footersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

/*!
 @abstract Translates the content of a section to RTF
 */
+ (NSString *)contentForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

@end

@implementation RKSectionWriter

NSDictionary *RSectionWriterFootnoteStyleNames;

+ (void)initialize
{
	RSectionWriterFootnoteStyleNames =
		@{[NSNumber numberWithInt:RKFootnoteEnumerationDecimal]: @"ar",
		  [NSNumber numberWithInt:RKFootnoteEnumerationRomanLowerCase]: @"rlc",
		  [NSNumber numberWithInt:RKFootnoteEnumerationRomanUpperCase]: @"ruc",
		  [NSNumber numberWithInt:RKFootnoteEnumerationAlphabeticLowerCase]: @"alc",
		  [NSNumber numberWithInt:RKFootnoteEnumerationAlphabeticUpperCase]: @"auc",
		  [NSNumber numberWithInt:RKFootnoteEnumerationChicagoManual]: @"chi"};
}

+ (NSString *)RTFFromSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
    NSString *sectionAttributes = [self sectionAttributesForSection:section usingDocument:resources.document];

    NSString *headers = [self headersForSection:section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources];
    NSString *footers = [self footersForSection:section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources];
    NSString *content = [self contentForSection:section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources];
    
    return [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@", sectionAttributes, headers, footers, content];
}

+ (NSString *)sectionAttributesForSection:(RKSection *)section usingDocument:(RKDocument *)document
{
    NSMutableString *attributes = [NSMutableString stringWithString:@"\\titlepg"];
    
    [attributes appendFormat: @"\\cols%lu", section.numberOfColumns];
    
    if (section.numberOfColumns > 1)
        [attributes appendFormat:@"\\colsx%lu", (NSUInteger)RKPointsToTwips(section.columnSpacing)];
    
    if (section.indexOfFirstPage != RKContinuousPageNumbering)
        [attributes appendFormat: @"\\pgnstarts%lu\\pgnrestart", section.indexOfFirstPage];
    
    switch (section.pageNumberingStyle) {
        case RKPageNumberingDecimal:
            [attributes appendFormat: @"\\pgndec"];
            break;

        case RKPageNumberingRomanLowerCase:
            [attributes appendFormat: @"\\pgnlcrm"];
            break;

        case RKPageNumberingRomanUpperCase:
            [attributes appendFormat: @"\\pgnucrm"];
            break;

        case RKPageNumberingAlphabeticUpperCase:
            [attributes appendFormat: @"\\pgnucltr"];
            break;

        case RKPageNumberingAlphabeticLowerCase:
            [attributes appendFormat: @"\\pgnlcltr"];
            break;
    }
    
	// Ensure footnote placement at the bottom of a page
    [attributes appendString:@"\\sftnbj\\saftnbj"];

	
    // Footnote syling
    NSString *footnoteStyle = RSectionWriterFootnoteStyleNames[[NSNumber numberWithInt:document.footnoteEnumerationStyle]];
    
    if (footnoteStyle != nil)
        [attributes appendFormat:@"\\sftnn%@", footnoteStyle];
	
    // Endnote layouting (using \aftnn and \saftn improves compatibility with Word)
    NSString *endnoteStyle = RSectionWriterFootnoteStyleNames[[NSNumber numberWithInt:document.endnoteEnumerationStyle]];
    
    if (footnoteStyle != nil)
        [attributes appendFormat:@"\\saftnn%@", endnoteStyle];

	// Set endnote placement, if endnotes are enumerated per section
	if (document.endnotePlacement == RKEndnotePlacementSectionEnd)
		[attributes appendFormat: @"\\endnhere"];
	
    // Footnote restart policy
    switch (document.footnoteEnumerationPolicy) {
        case (RKFootnoteEnumerationPerPage):
            [attributes appendString:@"\\sftnrstpg"];
            break;
        case (RKFootnoteEnumerationPerSection):
            [attributes appendString:@"\\sftnrestart"];
            break;
        case (RKFootnoteContinuousEnumeration):
            [attributes appendString:@"\\sftnrstcont"];
            break;
    }
	
    return attributes;
}

+ (NSString *)translateAttributedStringMap:(NSDictionary *)attributedStringMap
                   withConversionPolicy:(RKConversionPolicy)conversionPolicy 
                              resources:(RKResourcePool *)resources
{
    NSMutableString *translation = [NSMutableString new];    
    
    for (NSString *tag in [attributedStringMap.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        NSAttributedString *attributedString = attributedStringMap[tag];

		NSString *bodyString = [RKAttributedStringWriter RTFFromAttributedString:attributedString withConversionPolicy:conversionPolicy resources:resources];
		// Add a \par control word, otherwise word will ignore paragraph stylings
		if (![bodyString rangeOfString:@"\\\\par\\s+" options:NSRegularExpressionSearch|NSAnchoredSearch|NSBackwardsSearch].length)
			bodyString = [bodyString stringByAppendingString: @"\\par"];
		
        [translation appendString:
         [NSString stringWithRTFGroupTag:tag body:bodyString]
        ];
		
        [translation appendString: @"\n"];
    }

    return translation;
}

+ (NSString *)headersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];

    NSAttributedString *leftHeader = [section headerForPage: RKPageSelectionLeft];
    NSAttributedString *rightHeader = [section headerForPage: RKPageSelectionRight];
    NSAttributedString *firstHeader = [section headerForPage: RKPageSelectionFirst];         
    
    if (leftHeader)
        translationTable[@"headerl"] = leftHeader;

    if (rightHeader)
        translationTable[@"headerr"] = rightHeader;

    if (firstHeader)
        translationTable[@"headerf"] = firstHeader;


    return [self translateAttributedStringMap:translationTable withConversionPolicy:conversionPolicy resources:resources];

}

+ (NSString *)footersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];
    
    NSAttributedString *leftFooter = [section footerForPage: RKPageSelectionLeft];
    NSAttributedString *rightFooter = [section footerForPage: RKPageSelectionRight];
    NSAttributedString *firstFooter = [section footerForPage: RKPageSelectionFirst];         
    
    if (leftFooter)
        translationTable[@"footerl"] = leftFooter;
    
    if (rightFooter)
        translationTable[@"footerr"] = rightFooter;
    
    if (firstFooter)
        translationTable[@"footerf"] = firstFooter;
    
    return [self translateAttributedStringMap:translationTable withConversionPolicy:conversionPolicy resources:resources];
}

+ (NSString *)contentForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
    return [RKAttributedStringWriter RTFFromAttributedString:section.content withConversionPolicy:conversionPolicy resources:resources];
}

@end
