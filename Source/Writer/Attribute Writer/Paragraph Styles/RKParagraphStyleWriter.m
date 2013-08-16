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
 @abstract Generates the required tags for styling a paragraph
 */
+ (NSString *)styleTagWithWritingDirection:(CTWritingDirection)baseWritingDirection textAlignment:(CTTextAlignment)textAlignment headIndent:(CGFloat)headIndent firstLineHeadIndent:(CGFloat)firstLineHeadIndent tailIndent:(CGFloat)tailIndent lineSpacing:(CGFloat)lineSpacing lineHeightMultiple:(CGFloat)lineHeightMultiple minimumLineHeight:(CGFloat)minimumLineHeight maximumLineHeight:(CGFloat)maximumLineHeight paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore paragraphSpacingAfter:(CGFloat)paragraphSpacing defaultTabInterval:(CGFloat)defaultTabInterval ofAttributedString:(NSAttributedString *)attributedString paragraphRange:(NSRange)range resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the style tags required to describe the writing direction of a paragraph
 */
+ (NSString *)styleTagsForWritingDirection:(CTWritingDirection)writingDirection;

/*!
 @abstract Generates the style tags required to describe the text alignment of a paragraph
 */
+ (NSString *)styleTagsForTextAlignment:(CTTextAlignment)textAlignment;

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

#if !TARGET_OS_IPHONE
/*!
 @abstract Generates the style tags required to describe a single tab stop of a paragraph
 */
+ (NSString *)styleTagsForTabStopType:(NSTextTabType)tabType location:(CGFloat)location;

#else

/*!
 @abstract Generates the style tags required to describe a single tab stop of a paragraph
 */
+ (NSString *)styleTagsForTabAlignment:(CTTextAlignment)tabType location:(CGFloat)location;

#endif

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




#pragma mark - Plattform-dependend styling

#if !TARGET_OS_IPHONE
+ (NSString *)styleTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources
{
    if (!paragraphStyle)
        return @"";
    
    NSMutableString *rtf = [NSMutableString new];

    // Generate basic paragraph style settings
    [rtf appendString:  
     [self styleTagWithWritingDirection:paragraphStyle.baseWritingDirection 
                          textAlignment:paragraphStyle.alignment 
                             headIndent:paragraphStyle.headIndent 
                    firstLineHeadIndent:paragraphStyle.firstLineHeadIndent 
                             tailIndent:paragraphStyle.tailIndent 
                            lineSpacing:paragraphStyle.lineSpacing 
                     lineHeightMultiple:paragraphStyle.lineHeightMultiple 
                      minimumLineHeight:paragraphStyle.minimumLineHeight 
                      maximumLineHeight:paragraphStyle.maximumLineHeight 
                 paragraphSpacingBefore:paragraphStyle.paragraphSpacingBefore 
                  paragraphSpacingAfter:paragraphStyle.paragraphSpacing 
                     defaultTabInterval:paragraphStyle.defaultTabInterval 
                     ofAttributedString:attributedString 
                         paragraphRange:range 
                              resources:resources
      ]
     ];
    
    // Translation of tab stops    
    for (NSTextTab *tabStop in paragraphStyle.tabStops) {
        [rtf appendString: [self styleTagsForTabStopType:tabStop.tabStopType location:tabStop.location]];
    }
    
    // Just to separate from succeeding text or tags
    [rtf appendString: @" "];
    
    return rtf;
}

#else

+ (NSString *)styleTagFromParagraphStyle:(id)paragraphStyleObject ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources
{
    if (!paragraphStyleObject)
        return @"";
    
    // Load values from paragraph style
    BOOL success;
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)paragraphStyleObject;
    
    CTWritingDirection baseWritingDirection;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection);
    NSAssert(success, @"Can't load style value");

    CTTextAlignment textAlignment;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment);
    NSAssert(success, @"Can't load style value");
    
    CGFloat headIndent;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
    NSAssert(success, @"Can't load style value");
    
    CGFloat firstLineHeadIndent;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
    NSAssert(success, @"Can't load style value");
    
    CGFloat tailIndent;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent);
    NSAssert(success, @"Can't load style value");
    
    CGFloat lineSpacing;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing);
    NSAssert(success, @"Can't load style value");
    
    CGFloat lineHeightMultiple;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple);
    NSAssert(success, @"Can't load style value");
    
    CGFloat maximumLineHeight;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight);
    NSAssert(success, @"Can't load style value");
    
    CGFloat minimumLineHeight;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight);
    NSAssert(success, @"Can't load style value");
    
    CGFloat paragraphSpacingBefore;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore);
    NSAssert(success, @"Can't load style value");
    
    CGFloat paragraphSpacing;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing);
    NSAssert(success, @"Can't load style value");
    
    CGFloat defaultTabInterval;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval);
    NSAssert(success, @"Can't load style value");
    
    CFArrayRef tabStops;
    success = CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops);
    NSAssert(success, @"Can't load style value");
    
    // Generate basic paragraph style
    NSMutableString *rtf = [NSMutableString new];
    
    [rtf appendString:
     [self styleTagWithWritingDirection:baseWritingDirection 
                         textAlignment:textAlignment 
                            headIndent:headIndent 
                   firstLineHeadIndent:firstLineHeadIndent 
                            tailIndent:tailIndent 
                           lineSpacing:lineSpacing 
                    lineHeightMultiple:lineHeightMultiple 
                     minimumLineHeight:minimumLineHeight 
                     maximumLineHeight:maximumLineHeight 
                paragraphSpacingBefore:paragraphSpacingBefore 
                 paragraphSpacingAfter:paragraphSpacing 
                    defaultTabInterval:defaultTabInterval 
                    ofAttributedString:attributedString 
                        paragraphRange:range 
                             resources:resources
      ]];
     
    // Generate tab stops
    for (id tabStopObject in (__bridge NSArray *)tabStops) {
        CTTextTabRef tabStop = (__bridge CTTextTabRef)tabStopObject;
        
        [rtf appendString: [self styleTagsForTabAlignment:CTTextTabGetAlignment(tabStop) location:CTTextTabGetLocation(tabStop)]];
    }
    
    // To prevent conflicts with succeeding text, we add a space
    [rtf appendString:@" "];
    
    return rtf;
}
#endif




#pragma mark - Plattform-independend styling method

+ (NSString *)styleTagWithWritingDirection:(CTWritingDirection)baseWritingDirection textAlignment:(CTTextAlignment)textAlignment headIndent:(CGFloat)headIndent firstLineHeadIndent:(CGFloat)firstLineHeadIndent tailIndent:(CGFloat)tailIndent lineSpacing:(CGFloat)lineSpacing lineHeightMultiple:(CGFloat)lineHeightMultiple minimumLineHeight:(CGFloat)minimumLineHeight maximumLineHeight:(CGFloat)maximumLineHeight paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore paragraphSpacingAfter:(CGFloat)paragraphSpacing defaultTabInterval:(CGFloat)defaultTabInterval ofAttributedString:(NSAttributedString *)attributedString paragraphRange:(NSRange)range resources:(RKResourcePool *)resources
{
    NSMutableString *rtf = [NSMutableString new];
    
    // For compatibility reason, this must be executed in the given order    
    [rtf appendString: [self styleTagsForWritingDirection: baseWritingDirection]];
    [rtf appendString: [self styleTagsForTextAlignment: textAlignment]];    
    [rtf appendString: [self styleTagsForHeadIndent:headIndent firstLineHeadIndent:firstLineHeadIndent tailIndent:tailIndent resources:resources]];
    [rtf appendString: [self styleTagsForLineSpacing: lineSpacing]];
    [rtf appendString: [self styleTagsForLineHeightMultiple:lineHeightMultiple attributedString:attributedString paragraphRange:range]];    
    [rtf appendString: [self styleTagsForMinimumLineHeight:minimumLineHeight maximumLineHeight:maximumLineHeight]];    
    [rtf appendString: [self styleTagsForParagraphSpacingBefore:paragraphSpacingBefore after:paragraphSpacing]];
    
    // Default tab interval
    // (While the Cocoa reference says this defaults to "0", it seems to default to "36" - so we will be explicit here)
    [rtf appendString: [self styleTagsForDefaultTabInterval:defaultTabInterval]];    
    
    return rtf;
}



#pragma mark - Paragraph styling tags

+ (NSString *)styleTagsForWritingDirection:(CTWritingDirection)baseWritingDirection
{
    if (baseWritingDirection == kCTWritingDirectionRightToLeft)
        return @"\\rtlpar";    
    
    return @"";
}

+ (NSString *)styleTagsForTextAlignment:(CTTextAlignment)textAlignment
{
    switch (textAlignment) {
        case kCTLeftTextAlignment:
            return @"\\ql";
            
        case kCTRightTextAlignment:
            return @"\\qr";
            
        case kCTCenterTextAlignment:
            return @"\\qc";
            
        case kCTJustifiedTextAlignment:
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
            CGFloat pageInnerWidth = resources.document.pageSize.width - resources.document.pageInsets.left - resources.document.pageInsets.right;
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

#if !TARGET_OS_IPHONE

+ (NSString *)styleTagsForTabStopType:(NSTextTabType)tabType location:(CGFloat)location
{
    NSMutableString *rtf = [NSMutableString new];    

    switch (tabType) {
        case NSCenterTabStopType:
            [rtf appendString:@"\\tqc"];
            break;
            
        case NSRightTabStopType:
            [rtf appendString:@"\\tqr"];
            break;
            
        case NSDecimalTabStopType:
            [rtf appendString:@"\\tqdec"];
            break;
    }
    
    [rtf appendFormat:@"\\tx%lu", (NSUInteger)RKPointsToTwips(location)];
    
    return rtf;
}

#else

+ (NSString *)styleTagsForTabAlignment:(CTTextAlignment)tabType location:(CGFloat)location
{
    NSMutableString *rtf = [NSMutableString new];    

    // On CoreText decimal-point tabs are not available
    switch (tabType) {
        case kCTCenterTextAlignment:
            [rtf appendString:@"\\tqc"];
            break;
            
        case kCTRightTextAlignment:
            [rtf appendString:@"\\tqr"];
            break;
            
        default:
            break;
    }
    
    [rtf appendFormat:@"\\tx%lu", (NSUInteger)RKPointsToTwips(location)];
    
    return rtf;
}

#endif

@end
