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

@interface RKListItemWriter ()

/*!
 @abstract Updates the paragraph style of an attributed string at a certain range according to the given tab stop and indentation settings.
 */
+ (void)updateParagraphStyleOfAttributedString:(NSMutableAttributedString *)attributedString inRange:(NSRange)range usingTabAlignments:(NSArray *)tabAlignments tabLocations:(NSArray *)tabLocations firstLineHeadIndentOfset:(CGFloat)firstLineHeadIndentOffset headIndentOffset:(CGFloat)headIndentOffset;

/*!
 @abstract Updates the given paragraph style according to the given tab stop and indentation settings.
*/
+ (void)updateParagraphStyle:(RKParagraphStyleWrapper *)paragraphStyle usingTabAlignments:(NSArray *)tabAlignments tabLocations:(NSArray *)tabLocations firstLineHeadIndentOfset:(CGFloat)firstLineHeadIndentOffset headIndentOffset:(CGFloat)headIndentOffset;

@end

@implementation RKListItemWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKTextListItemAttributeName priority:RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel];
    }
}

+ (void)preprocessAttribute:(NSString *)attributeName
                      value:(RKListItem *)listItem
             effectiveRange:(NSRange)range
         ofAttributedString:(NSMutableAttributedString *)preprocessedString
{
    if (!listItem)
        return;
    
    // Get paragraph style of list item
    RKListStyle *listStyle = listItem.listStyle;
    
    // No changes in the paragraph styling requested
    if (!listStyle.firstLineHeadIndentOffsets && !listStyle.headIndentOffsets && !listStyle.tabStopLocations)
        return;

    // Get indentation
    CGFloat firstLineHeadIndentOffset = 0;
    CGFloat headIndentOffset = 0;
    
    if (listStyle.firstLineHeadIndentOffsets.count > listItem.indentationLevel)
        firstLineHeadIndentOffset = [[listStyle.firstLineHeadIndentOffsets objectAtIndex: listItem.indentationLevel] floatValue];
    
    if (listStyle.headIndentOffsets.count > listItem.indentationLevel)
        headIndentOffset = [[listStyle.headIndentOffsets objectAtIndex: listItem.indentationLevel] floatValue];

    // Adjust tab stops
    NSArray *tabLocations = nil;
    NSArray *tabAlignments = nil;
    
    if ((listStyle.tabStopLocations.count > listItem.indentationLevel) && (listStyle.tabStopAlignments.count > listItem.indentationLevel)) {
        tabLocations = listStyle.tabStopLocations[listItem.indentationLevel];
        tabAlignments = listStyle.tabStopAlignments[listItem.indentationLevel];
    }
        
    // Update paragraph style
    [self updateParagraphStyleOfAttributedString:preprocessedString inRange:range usingTabAlignments:tabAlignments tabLocations:tabLocations firstLineHeadIndentOfset:firstLineHeadIndentOffset headIndentOffset:headIndentOffset];
}

#if !TARGET_OS_IPHONE
+ (void)updateParagraphStyleOfAttributedString:(NSMutableAttributedString *)attributedString inRange:(NSRange)range usingTabAlignments:(NSArray *)tabAlignments tabLocations:(NSArray *)tabLocations firstLineHeadIndentOfset:(CGFloat)firstLineHeadIndentOffset headIndentOffset:(CGFloat)headIndentOffset
{
    // Get paragraph style
    NSMutableParagraphStyle *nsParagraphStyle = [[attributedString attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL] mutableCopy];
    if (!nsParagraphStyle)
        nsParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    // Update paragraph style
    RKParagraphStyleWrapper *paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: nsParagraphStyle];
    
    [self updateParagraphStyle:paragraphStyle usingTabAlignments:tabAlignments tabLocations:tabLocations firstLineHeadIndentOfset:firstLineHeadIndentOffset headIndentOffset:headIndentOffset];
    
    // Update attribute
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle.newNSParagraphStyle range:range];
}
#else

+ (void)updateParagraphStyleOfAttributedString:(NSMutableAttributedString *)attributedString inRange:(NSRange)range usingTabAlignments:(NSArray *)tabAlignments tabLocations:(NSArray *)tabLocations firstLineHeadIndentOfset:(CGFloat)firstLineHeadIndentOffset headIndentOffset:(CGFloat)headIndentOffset
{
    RKParagraphStyleWrapper *paragraphStyle = nil;
    
    // Get paragraph style
    CTParagraphStyleRef ctParagraphStyle = (__bridge CTParagraphStyleRef)[[attributedString attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL] mutableCopy];
    
    // Use default paragraph style otherwise
    if (!ctParagraphStyle) {
        ctParagraphStyle = CTParagraphStyleCreate(NULL, 0);
        paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle:ctParagraphStyle];
        
        CFRelease(ctParagraphStyle);
    }
    
    paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle:ctParagraphStyle];
    
    // Update paragraph style
    [self updateParagraphStyle:paragraphStyle usingTabAlignments:tabAlignments tabLocations:tabLocations firstLineHeadIndentOfset:firstLineHeadIndentOffset headIndentOffset:headIndentOffset];

    CTParagraphStyleRef updatedStyle = paragraphStyle.newCTParagraphStyle;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:(__bridge id)updatedStyle range:range];
    
    CFRelease(updatedStyle);
}

#endif

+ (void)updateParagraphStyle:(RKParagraphStyleWrapper *)paragraphStyle usingTabAlignments:(NSArray *)tabAlignments tabLocations:(NSArray *)tabLocations firstLineHeadIndentOfset:(CGFloat)firstLineHeadIndentOffset headIndentOffset:(CGFloat)headIndentOffset
{
    // Update Indentation
    paragraphStyle.firstLineHeadIndent += firstLineHeadIndentOffset;
    paragraphStyle.headIndent += headIndentOffset;
    
    // Setup new NSTextTabs instances for the given tabs stops
    NSMutableArray *newTabStops = [NSMutableArray new];
    
    for (NSUInteger tabIndex = 0; tabIndex < tabLocations.count; tabIndex ++) {
        CGFloat location = [[tabLocations objectAtIndex: tabIndex] floatValue] + firstLineHeadIndentOffset;
        NSUInteger alignment = tabAlignments.count > tabIndex ? [[tabAlignments objectAtIndex: tabIndex] unsignedIntegerValue] : 0;
        
        RKTextTabWrapper *newTab = [RKTextTabWrapper new];
        newTab.tabAlignment = alignment;
        newTab.location = location;
        
        [newTabStops addObject: newTab];
    }
    
    paragraphStyle.tabStops = newTabStops;
}


+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(RKListItem *)listItem
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (listItem) {
        NSUInteger listIndex = [resources.listCounter indexOfListStyle: listItem.listStyle];
        NSArray *itemNumbers = [resources.listCounter incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.listStyle];
        
        NSString *markerString = [RKListStyle systemCompatibleMarker: [[listItem.listStyle markerForItemNumbers:itemNumbers] RTFEscapedString]];

        // Register the list marker
        [taggedString registerTag:[NSString stringWithFormat:@"\\ls%li\\ilvl%li {\\listtext%@}", listIndex, listItem.indentationLevel, markerString] forPosition:range.location];
    }
}

@end
