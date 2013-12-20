//
//  RKHeaderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriter.h"
#import "RKResourcePool.h"
#import "RKConversion.h"
#import "RKListStyle+WriterAdditions.h"
#import "RKAttributedStringWriter.h"

// Used to access the RKHeaderWriterMetadataDescriptions 
enum {
    RKMetaDescriptionAccessorKey = 0,
    RKMetaDescriptionExportedTag = 1,
    RKMetaDescriptionExpectedType = 2
};

@interface RKHeaderWriter()

/*!
 @abstract Generates the font table using a resource manager
 */
+ (NSString *)fontTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generates the color table using a resource manager
 */
+ (NSString *)colorTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generates a style sheet setting from a dictionary containing style definitions
 */
+ (NSString *)styleSheetsFromStyleDefinitions:(NSDictionary *)styleDefinitions paragraphStyle:(BOOL)isParagraphStyle resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the style sheet settings using a resource manager
 */
+ (NSString *)styleSheetsFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generate a list level using a resource manager
 */
+ (NSString *)entryForLevel:(NSUInteger)level inList:(RKListStyle*)list listIndex:(NSUInteger)listIndex resources:(RKResourcePool *)resources;

/*!
 @abstract Generate the list table using a resource manager
 */
+ (NSString *)listTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generate the list override table using a resource manger
 */
+ (NSString *)listOverrideTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generates the document informations from a document
 */
+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document;

/*!
 @abstract Generates the document layout settings from a document
 */
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;

@end

@implementation RKHeaderWriter

NSArray *RKHeaderWriterMetadataDescriptions;

+ (void)initialize
{
    // An ordered lookup table mapping from the field keys to the field titles and types representing RTF document meta data
    RKHeaderWriterMetadataDescriptions = 
                           @[@[RKTitleDocumentAttribute,                @"\\title",         [NSString class]],
                            @[RKCompanyDocumentAttribute,              @"\\*\\company",    [NSString class]],
                            @[RKCopyrightDocumentAttribute,            @"\\*\\copyright",  [NSString class]],
                            @[RKSubjectDocumentAttribute,              @"\\subject",       [NSString class]],
                            @[RKAuthorDocumentAttribute,               @"\\author",        [NSString class]],
                            @[RKKeywordsDocumentAttribute,             @"\\keywords",      [NSArray class]],
                            @[RKCommentDocumentAttribute,              @"\\doccomm",       [NSString class]],
                            @[RKEditorDocumentAttribute,               @"\\*\\editor",     [NSString class]],
                            @[RKCreationTimeDocumentAttribute,         @"\\creatim",       [NSDate class]],
                            @[RKModificationTimeDocumentAttribute,     @"\\revtim",        [NSDate class]],
                            @[RKManagerDocumentAttribute,              @"\\manager",       [NSString class]],
                            @[RKCategoryDocumentAttribute,             @"\\category",      [NSString class]]];
}

+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourcePool *)resources
{
    return [NSString stringWithFormat:@"\\rtf1\\ansi\\ansicpg1252\\uc0\n%@\n%@\n%@\n%@\n%@\n%@\n%@%@",
            [RKHeaderWriter fontTableFromResourceManager: resources],
            [RKHeaderWriter colorTableFromResourceManager: resources],
            [RKHeaderWriter styleSheetsFromResourceManager: resources],
            [RKHeaderWriter listTableFromResourceManager: resources],
            [RKHeaderWriter listOverrideTableFromResourceManager: resources],
            [RKHeaderWriter documentMetaDataFromDocument: document],
            [RKHeaderWriter documentFormatFromDocument: document],
			[RKHeaderWriter footnoteStyleFromResourceManager: resources]
           ];
}

+ (NSString *)footnoteStyleFromResourceManager:(RKResourcePool *)resources
{
	if (!resources.containsFootnotes)
		return @"\n";
	
	NSString *alignmentCommand = resources.document.footnoteAreaDividerPosition == NSLeftTextAlignment ? @"\\ql" : @"\\qr";
	
	// Setup line height and paragraph spacing after to control footnote area spacing
	NSString *separatorStyle = [NSString stringWithFormat: @"\\pard %@ \\sa%li \\sl%li\\slmult0 ", alignmentCommand, (NSInteger)RKPointsToTwips(resources.document.footnoteAreaDividerSpacingAfter), (NSInteger)RKPointsToTwips(resources.document.footnoteAreaDividerSpacingBefore)];
	
	// 'ftnsep' etc. are RTF control words to style the separator area. 'chftnsep' will be replaced by the footnote separator line.
	return [NSString stringWithFormat: @"\n{\\ftnsep %@ \\chftnsep \\par}{\\ftnsepc %@ \\chftnsepc \\par}{\\aftnsep %@ \\chftnsep \\par}{\\aftnsepc %@ \\chftnsepc \\par}\n", separatorStyle, separatorStyle, separatorStyle, separatorStyle];
}

+ (NSString *)fontTableFromResourceManager:(RKResourcePool *)resources
{
    NSMutableString *fontTable = [NSMutableString stringWithString:@"{\\fonttbl"];
    
    [resources.fontFamilyNames enumerateObjectsUsingBlock:^(NSString *fontFamilyName, NSUInteger index, BOOL *stop) {
        [fontTable appendFormat:@"\\f%li\\fnil\\fcharset0 %@;", index, fontFamilyName];
    }];
    
    [fontTable appendString: @"}"];
    
    return fontTable;
}

+ (NSString *)colorTableFromResourceManager:(RKResourcePool *)resources
{
    NSArray *colors = resources.colors;
    colors = [colors subarrayWithRange:NSMakeRange(1, colors.count - 1)];
    
    return [NSMutableString stringWithFormat:@"{\\colortbl;%@;}", [colors componentsJoinedByString: @";"]];
}

+ (NSString *)styleSheetsFromStyleDefinitions:(NSDictionary *)styleDefinitions paragraphStyle:(BOOL)isParagraphStyle resources:(RKResourcePool *)resources
{
    __block NSMutableString *collectedStyleSheets = [NSMutableString new];
    
    [styleDefinitions enumerateKeysAndObjectsUsingBlock:^(NSString *styleName, NSDictionary *styleDefinition, BOOL *stop) {
        NSString *styleTag = (isParagraphStyle) ? @"\\s" : @"\\cs";
        NSUInteger styleIndex = (isParagraphStyle) ? [resources indexOfParagraphStyle: styleName] : [resources indexOfCharacterStyle: styleName];
        
        // We need sqformat to make the style visible in the UI of Microsoft Word
        [collectedStyleSheets appendFormat:@"{%@%lu%@ %@\\sqformat\\sbasedon0 %@;}",
         styleTag,
         styleIndex,
         (isParagraphStyle) ? @"" : @"\\additive",
         [RKAttributedStringWriter stylesheetTagsFromAttributes:styleDefinition resources:resources],
         [styleName RTFEscapedString]
         ];
    }];    
    
    return collectedStyleSheets;
}

+ (NSString *)styleSheetsFromResourceManager:(RKResourcePool *)resources
{
    return [NSString stringWithFormat:@"{\\stylesheet %@%@}",
            [self styleSheetsFromStyleDefinitions:resources.document.paragraphStyles paragraphStyle:YES resources:resources],
            [self styleSheetsFromStyleDefinitions:resources.document.characterStyles paragraphStyle:NO resources:resources]
           ];
}

+ (NSString *)listTableFromResourceManager:(RKResourcePool *)resources
{
    NSDictionary *listStyles = resources.listCounter.listStyles;
    
    if (listStyles.count == 0)
        return @"";
    
    NSMutableString *listTable = [NSMutableString stringWithString:@"{\\*\\listtable "];
    
    [listStyles enumerateKeysAndObjectsUsingBlock:^(NSNumber *listIndex, RKListStyle *listStyle, BOOL *stop) {
        NSMutableString *listLevelsString = [NSMutableString new];
        
        for (NSUInteger levelIndex = 0; levelIndex < listStyle.numberOfLevels; levelIndex ++)  {
            [listLevelsString appendString: [self entryForLevel:levelIndex inList:listStyle listIndex:listIndex.unsignedIntegerValue resources:resources]];
        }
                
        [listTable appendFormat:@"{\\list\\listtemplateid%@\\listhybrid%@\\listid%@{\\listname list%@}}",
         listIndex,
         listLevelsString,
         listIndex,
         listIndex
         ];
    }];
    
    [listTable appendString:@"}\n"];
    
    return listTable;
}

+ (NSString *)entryForLevel:(NSUInteger)level inList:(RKListStyle*)list listIndex:(NSUInteger)listIndex resources:(RKResourcePool *)resources
{
    NSArray *placeholderPositions;
    NSString *rtfFormatString = [NSString stringWithFormat:@"{\\leveltext\\leveltemplateid%lu %@;}", 
                                 (listIndex * 10) + level,
                                 [list formatStringOfLevel:level placeholderPositions:&placeholderPositions]
                                ];
    
    // Generate placeholder formatting (Word requires a positioning string for all placeholders)
    NSMutableString *rtfPlaceholderPostions = [NSMutableString stringWithString:@"{\\levelnumbers "];
    
    for (NSNumber *placeholderPosition in placeholderPositions) {
        [rtfPlaceholderPostions appendFormat:@"\\'%.2lx", [placeholderPosition unsignedIntegerValue]];
    }
    
    [rtfPlaceholderPostions appendString:@";}"];
    
    // Cocoa-specific format string
    NSString *textSystemFormatString = [list systemFormatOfLevel: level];
    
    // Additional parameters
    NSUInteger formatCode = [list formatCodeOfLevel:level];
    NSUInteger startNumber = [list startNumberForLevel:level];
    
	NSDictionary *markerStyle = [list markerStyleForLevel: level] ;
	NSString *markerStyleString = markerStyle ? [RKAttributedStringWriter stylesheetTagsFromAttributes:markerStyle resources:resources] : @"";
	
    // Generate level description
    return [NSString stringWithFormat:@"{\\listlevel\\levelstartat%lu\\levelnfc%lu"
                                        "\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                                        "%@%@%@%@"
                                        "\\levelfollow0\\levellegal0\\levelnorestart0}",
            startNumber,
            formatCode,
            textSystemFormatString,
            rtfFormatString,
            rtfPlaceholderPostions,
			markerStyleString
            ];
}

+ (NSString *)listOverrideTableFromResourceManager:(RKResourcePool *)resources
{
    NSDictionary *listStyles = resources.listCounter.listStyles;
    
    if (listStyles.count == 0)
        return @"";

    NSMutableString *overrideTable = [NSMutableString stringWithString:@"{\\*\\listoverridetable"];
    
    [listStyles enumerateKeysAndObjectsUsingBlock:^(NSNumber *listIndex, RKListStyle *listStyle, BOOL *stop) {
        [overrideTable appendFormat:@"{\\listoverride\\listid%@\\listoverridecount0\\ls%@}", listIndex, listIndex];
    }];

    
    [overrideTable appendString:@"}\n"];
    
    return overrideTable;
}

+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document
{
    NSMutableString *infoTable = [NSMutableString stringWithString:@"{\\info"];
    
    for (NSArray *description in RKHeaderWriterMetadataDescriptions) {
        id itemValue = (document.metadata)[description[RKMetaDescriptionAccessorKey]];
        
        if (itemValue) {
            NSString *convertedValue;
            
            if ([description[RKMetaDescriptionExpectedType] isEqual: [NSString class]]) {
                convertedValue = [itemValue RTFEscapedString];
            }
             else if ([description[RKMetaDescriptionExpectedType] isEqual: [NSArray class]]) {
                 NSArray *arrayItem = itemValue;
                 convertedValue = [arrayItem componentsJoinedByString:@", "];
            }
             else if ([description[RKMetaDescriptionExpectedType] isEqual: [NSDate class]]) {
                convertedValue = [itemValue RTFDate];
            }
            else {
                NSAssert(false, @"Invalid meta data definitions");
            }
            
            [infoTable appendFormat:@"{%@ %@}", description[RKMetaDescriptionExportedTag], convertedValue];
        }
    }
    
    [infoTable appendString: @"}"];
    
    return infoTable;
}

+ (NSString *)documentFormatFromDocument:(RKDocument *)document
{
    NSMutableString *attributes = [NSMutableString new];
    
    // Footnote placement
    switch (document.footnotePlacement) {
        case RKFootnotePlacementSamePage:
            [attributes appendString:@"\\fet2"];
            break;
        case RKFootnotePlacementSectionEnd:
            [attributes appendString:@"\\fet1\\endnotes"];
            break;
        case RKFootnotePlacementDocumentEnd:
            [attributes appendString:@"\\fet1\\enddoc"];
            break;
    }
	
	// Ensure footnote placement at the bottom (seems to be ignored for endnotes).
    [attributes appendString:@"\\ftnbj\\aftnbj"];
	
    // Endnote placement
    switch (document.endnotePlacement) {
        case RKEndnotePlacementSectionEnd:
            [attributes appendString:@"\\aendnotes"];
            break;
        case RKEndnotePlacementDocumentEnd:
            [attributes appendString:@"\\aenddoc"];
            break;
    }
	
    // Footnote restart policy
    switch (document.footnoteEnumerationPolicy) {
        case (RKFootnoteEnumerationPerPage):
            [attributes appendString:@"\\ftnrstpg"];
            break;
        case (RKFootnoteEnumerationPerSection):
            [attributes appendString:@"\\ftnrestart"];
            break;
        case (RKFootnoteContinuousEnumeration):
            [attributes appendString:@"\\ftnrstcont"];
            break;
    }
    
    // Endnote restart policy
    switch (document.endnoteEnumerationPolicy) {
        case (RKFootnoteEnumerationPerSection):
            [attributes appendString:@"\\aftnrestart"];
            break;
            
        case (RKFootnoteContinuousEnumeration):
            [attributes appendString:@"\\aftnrstcont"];
            break;
            
        case (RKFootnoteEnumerationPerPage):
            NSAssert(false, @"Invalid policy for endnote enumeration");
            break;
    }
	
    // Page orientation
    if (document.pageOrientation == RKPageOrientationLandscape)
        [attributes appendString:@"\\landscape"];
    
	// Page binding
	switch (document.pageBinding) {
		case RKPageBindingLeft:
			break;
			
		case RKPageBindingRight:
			[attributes appendString: @"\\rtlgutter"];
			break;
	}

	// Double sided
	if (document.twoSided)
		[attributes appendString: @"\\facingp\\margmirror"];
	
    // Paper size
    [attributes appendString: [NSString stringWithFormat:@"\\paperw%lu\\paperh%lu",
							   (NSUInteger)RKPointsToTwips(document.pageSize.width), 
							   (NSUInteger)RKPointsToTwips(document.pageSize.height)
							   ]];
    
    // Margins
	switch (document.pageBinding) {
		case RKPageBindingLeft:
			[attributes appendString: [NSString stringWithFormat:@"\\margt%lu\\margl%lu\\margr%lu\\margb%lu",
									   (NSUInteger)RKPointsToTwips(document.pageInsets.top),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.inner),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.outer),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.bottom)
									   ]];
			break;
			
		case RKPageBindingRight:
			[attributes appendString: [NSString stringWithFormat:@"\\margt%lu\\margl%lu\\margr%lu\\margb%lu",
									   (NSUInteger)RKPointsToTwips(document.pageInsets.top),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.outer),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.inner),
									   (NSUInteger)RKPointsToTwips(document.pageInsets.bottom)
									   ]];
			break;
	}
	
    // Header / footer spacing
    if (document.headerSpacingBefore != 36)
        [attributes appendString: [NSString stringWithFormat:@"\\headery%lu",
                                   (NSUInteger)RKPointsToTwips(document.headerSpacingBefore)
                                   ]];
    
    if (document.footerSpacingAfter != 36)
        [attributes appendString: [NSString stringWithFormat:@"\\footery%lu",
                                   (NSUInteger)RKPointsToTwips(document.footerSpacingAfter)
                                   ]];
    
    
    // Hyphenation settings
    if (document.hyphenationEnabled)
        [attributes appendString:@"\\hyphauto1"];
    
    // We disable ANSI replacements for UNICODE charracters in general
    // To prevent conflicts with text following the formatting tags, add a space
    [attributes appendString:@"\\uc0 "];

    return attributes;
}

@end
