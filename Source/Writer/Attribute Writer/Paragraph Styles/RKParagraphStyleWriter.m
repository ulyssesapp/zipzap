//
//  RKParagraphStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKParagraphStyleWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"
#import "NSAttributedString+RKCalculationAdditions.h"

@interface RKParagraphStyleWriter ()

#if !TARGET_OS_IPHONE
/*!
 @abstract Generates the required tags for styling a paragraph
 */
+ (NSString *)styleTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources;

#else
/*!
 @abstract Generates the required tags for styling a paragraph
 */
+ (NSString *)styleTagFromParagraphStyle:(id)paragraphStyleObject ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources;

#endif

/*!
 @abstract Generates the style tags required to describe the writing direction of a paragraph
 */
+ (NSString *)styleTagsForWritingDirection:(NSWritingDirection)writingDirection;

/*!
 @abstract Generates the style tags required to describe the text alignment of a paragraph
 */
+ (NSString *)styleTagsForTextAlignment:(NSTextAlignment)textAlignment;

/*!
 @abstract Generates the style tags required to describe the indenting of a paragraph
 */
+ (NSString *)styleTagsForHeadIndent:(CGFloat)headIndent firstLineHeadIndent:(CGFloat)firstLineHeadIndent tailIndent:(CGFloat)tailIndent resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the style tags required to describe the line spacing of a paragraph
 */
+ (NSString *)styleTagsForLineSpacing:(CGFloat)lineSpacing;

/*!
 @abstract Generates the style tags required to describe the line height of a paragraph
 */
+ (NSString *)styleTagsForLineHeightMultiple:(CGFloat)lineHeightMultiple attributedString:(NSAttributedString *)attributedString paragraphRange:(NSRange)range;

/*!
 @abstract Generates the style tags required to describe the line height constraints of a paragraph
 */
+ (NSString *)styleTagsForMinimumLineHeight:(CGFloat)minimumLineHeight maximumLineHeight:(CGFloat)maximumLineHeight;

/*!
 @abstract Generates the style tags required to describe the spacing of a paragraph
 */
+ (NSString *)styleTagsForParagraphSpacingBefore:(CGFloat)before after:(CGFloat)after;

/*!
 @abstract Generates the style tags required to describe the default tab stop of a paragraph
 */
+ (NSString *)styleTagsForDefaultTabInterval:(CGFloat)defaultTabInterval;

/*!
 @abstract Generates the style tags required to describe a single tab stop of a paragraph
 */
+ (NSString *)styleTagsForTabAlignment:(NSTextAlignment)alignment location:(CGFloat)location;

@end

@implementation RKParagraphStyleWriter



#pragma mark - General methods for attribute writer

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKParagraphStyleAttributeName priority:RKAttributedStringWriterPriorityParagraphLevel];
    }
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(id)paragraphStyle
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
    if (!paragraphStyle)
        return;

    NSString *paragraphHeader = [self styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:range resources:resources];
    
    // We add \pard before each paragraph to reset the current paragraph styling
    [taggedString registerTag:@"\\pard " forPosition:range.location];
    [taggedString registerTag:paragraphHeader forPosition:range.location];
}

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(id)paragraphStyle
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources
{
    // If no paragraph style is given, no defaults should appear in a style sheet
    if (!paragraphStyle)    
        return @"";
    
    // To calculate the line height attribute in a style sheet, all RTF writers seem to use the line height of the style setting rather than the line height of the actual paragraph
    NSAttributedString *simulatedParagraph = [[NSAttributedString alloc] initWithString:@"A\n" attributes:styleSetting ];
    
    return [self styleTagFromParagraphStyle:paragraphStyle ofAttributedString:simulatedParagraph range:NSMakeRange(0, 2) resources:resources];
}

+ (NSString *)styleTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources
{
    if (!paragraphStyle)
        return @"";
    
	RKAdditionalParagraphStyle *additionalStyle = [attributedString attribute:RKAdditionalParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
    NSMutableString *rtf = [NSMutableString new];

	// Generate basic paragraph style settings
	// For compatibility reason, this must be executed in the given order
	[rtf appendString: [self styleTagsForWritingDirection: paragraphStyle.baseWritingDirection]];
	[rtf appendString: [self styleTagsForTextAlignment: paragraphStyle.alignment]];
	[rtf appendString: [self styleTagsForHeadIndent:paragraphStyle.headIndent firstLineHeadIndent:paragraphStyle.firstLineHeadIndent tailIndent:paragraphStyle.tailIndent resources:resources]];
	[rtf appendString: [self styleTagsForParagraphSpacingBefore:paragraphStyle.paragraphSpacingBefore after:paragraphStyle.paragraphSpacing]];
	
	// Ignore line height and line spacing if it is specified by an RKAdditionalParagraphStyle
	if (!additionalStyle.overrideLineHeightAndSpacing) {
		[rtf appendString: [self styleTagsForLineSpacing: paragraphStyle.lineSpacing]];
		[rtf appendString: [self styleTagsForLineHeightMultiple:paragraphStyle.lineHeightMultiple attributedString:attributedString paragraphRange:range]];
		[rtf appendString: [self styleTagsForMinimumLineHeight:paragraphStyle.minimumLineHeight maximumLineHeight:paragraphStyle.maximumLineHeight]];
	}
	
	// Default tab interval
	// (While the Cocoa reference says this defaults to "0", it seems to default to "36" - so we will be explicit here)
	[rtf appendString: [self styleTagsForDefaultTabInterval: paragraphStyle.defaultTabInterval]];
	
    // Translation of tab stops    
    for (NSTextTab *tabStop in paragraphStyle.tabStops) {
        [rtf appendString: [self styleTagsForTabAlignment:tabStop.alignment location:tabStop.location]];
    }
    
    // Just to separate from succeeding text or tags
    [rtf appendString: @" "];
    
    return rtf;
}


#pragma mark - Paragraph styling tags

+ (NSString *)styleTagsForWritingDirection:(NSWritingDirection)baseWritingDirection
{
    if (baseWritingDirection == NSWritingDirectionRightToLeft)
        return @"\\rtlpar";    
    
    return @"";
}

+ (NSString *)styleTagsForTextAlignment:(NSTextAlignment)textAlignment
{
    switch (textAlignment) {
        case RKTextAlignmentLeft:
            return @"\\ql";
            
        case RKTextAlignmentRight:
            return @"\\qr";
            
        case RKTextAlignmentCenter:
            return @"\\qc";
            
        case RKTextAlignmentJustified:
            return @"\\qj";
			
		default:
			return @"";
    }
}

+ (NSString *)styleTagsForHeadIndent:(CGFloat)headIndent firstLineHeadIndent:(CGFloat)firstLineHeadIndent tailIndent:(CGFloat)tailIndent resources:(RKResourcePool *)resources
{
    NSMutableString *rtf = [NSMutableString new];
    
    // Indenting of first line
    NSUInteger roundedFirstLineHeadIndent = RKPointsToTwips(firstLineHeadIndent - headIndent);
    
    if (roundedFirstLineHeadIndent != 0)
        [rtf appendFormat:@"\\fi%li",
         roundedFirstLineHeadIndent
         ];

    // General indenting
    NSUInteger roundedHeadIndent = RKPointsToTwips(headIndent);    
    
    if (roundedHeadIndent != 0)
        [rtf appendFormat:@"\\li%lu", roundedHeadIndent];
    
    // Tail indenting
    if ((NSInteger)RKPointsToTwips(tailIndent) != 0) {
        NSInteger indent;
        
        if (tailIndent > 0) {
            // Position is calculated from the leading margin
            CGFloat pageInnerWidth = resources.document.pageSize.width - resources.document.pageInsets.inner - resources.document.pageInsets.outer;
            indent = (NSInteger)RKPointsToTwips(pageInnerWidth - fabs(tailIndent));
        }
        else {
            // Position is calculated from the trailing margin
            indent = (NSInteger)RKPointsToTwips(fabs(tailIndent));
        }
        
        [rtf appendFormat:@"\\ri%li", indent];
    }
    
    return rtf;
}

+ (NSString *)styleTagsForLineSpacing:(CGFloat)lineSpacing
{
    NSUInteger roundedLineSpacing = RKPointsToTwips(lineSpacing);
    
    if (roundedLineSpacing != 0)
        return [NSString stringWithFormat:@"\\slleading%lu", roundedLineSpacing];
    
    return @"";
}

+ (NSString *)styleTagsForLineHeightMultiple:(CGFloat)lineHeightMultiple attributedString:(NSAttributedString *)attributedString paragraphRange:(NSRange)range
{
    if (lineHeightMultiple != 0) {
        CGFloat calculatedLineHeight = [attributedString pointSizeInRange:range] * lineHeightMultiple;
        return [NSString stringWithFormat:@"\\sl%lu\\slmult1", (NSUInteger)RKPointsToTwips(calculatedLineHeight)];
    }
    
    return @"";
}

+ (NSString *)styleTagsForMinimumLineHeight:(CGFloat)minimumLineHeight maximumLineHeight:(CGFloat)maximumLineHeight
{
    NSMutableString *rtf = [NSMutableString new];
    
    NSUInteger roundedMaximumLineHeight = RKPointsToTwips(maximumLineHeight);
    NSUInteger roundedMinimumLineHeight = RKPointsToTwips(minimumLineHeight); 
    
    if (roundedMaximumLineHeight != 0)
        [rtf appendFormat:@"\\slmaximum%lu", roundedMaximumLineHeight];
    
    if (roundedMinimumLineHeight != 0)
        [rtf appendFormat:@"\\slminimum%lu", roundedMinimumLineHeight];
    
    return rtf;
}

+ (NSString *)styleTagsForParagraphSpacingBefore:(CGFloat)beforeSpacing after:(CGFloat)afterSpacing
{
    NSMutableString *rtf = [NSMutableString new];    
    
    NSUInteger roundedBeforeSpacing = (NSUInteger)RKPointsToTwips(beforeSpacing);
    NSUInteger roundedAfterSpacing = (NSUInteger)RKPointsToTwips(afterSpacing);
    
    if (roundedBeforeSpacing != 0)
        [rtf appendFormat:@"\\sb%lu", roundedBeforeSpacing];
    
    if (roundedAfterSpacing != 0)
        [rtf appendFormat:@"\\sa%lu", roundedAfterSpacing];
    
    return rtf;
}

+ (NSString *)styleTagsForDefaultTabInterval:(CGFloat)defaultTabInterval
{
    return [NSString stringWithFormat:@"\\pardeftab%lu", (NSUInteger)RKPointsToTwips(defaultTabInterval)];    
}


#pragma mark - Styling of TAB definitions

+ (NSString *)styleTagsForTabAlignment:(NSTextAlignment)alignment location:(CGFloat)location
{
    NSMutableString *rtf = [NSMutableString new];    

    switch (alignment) {
		case RKTextAlignmentLeft:
		case RKTextAlignmentNatural:
		case RKTextAlignmentJustified:
			break;
			
        case RKTextAlignmentCenter:
            [rtf appendString:@"\\tqc"];
            break;
            
        case RKTextAlignmentRight:
            [rtf appendString:@"\\tqr"];
            break;
    }
    
    [rtf appendFormat:@"\\tx%lu", (NSUInteger)RKPointsToTwips(location)];
    
    return rtf;
}

@end
