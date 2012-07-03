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

    // Get paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[preprocessedString attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL] mutableCopy];
    
    if (!paragraphStyle)
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    // Get indentation
    CGFloat firstLineHeadIndentOffset = [listStyle.firstLineHeadIndentOffsets[listItem.indentationLevel] floatValue];
    CGFloat headIndentOffset = [listStyle.headIndentOffsets[listItem.indentationLevel] floatValue];
    
    // Add indentation according to indentation level of a list item
    if (listStyle.firstLineHeadIndentOffsets.count > listItem.indentationLevel)
        paragraphStyle.firstLineHeadIndent += firstLineHeadIndentOffset;
    
    if (listStyle.headIndentOffsets.count > listItem.indentationLevel)
        paragraphStyle.headIndent += headIndentOffset;

    // Adjust tab stops
    if ((listStyle.tabStopLocations.count > listItem.indentationLevel) && (listStyle.tabStopAlignments.count > listItem.indentationLevel)) {
        NSArray *tabStopLocations = listStyle.tabStopLocations[listItem.indentationLevel];
        NSArray *tabStopAlignments = listStyle.tabStopAlignments[listItem.indentationLevel];

        // Setup new NSTextTabs instances for the given tabs stops
        NSMutableArray *newTabStops = [NSMutableArray new];
        
        for (NSUInteger tabIndex = 0; tabIndex < tabStopLocations.count; tabIndex ++) {
            CGFloat location = [tabStopLocations[tabIndex] floatValue] + firstLineHeadIndentOffset;
            
            NSTextTab *newTab = [[NSTextTab alloc] initWithTextAlignment:[tabStopAlignments[tabIndex] unsignedIntegerValue] location:location options:nil];
            [newTabStops addObject: newTab];
        }
        
        paragraphStyle.tabStops = newTabStops;
    }
        
    // Update paragraph style
    [preprocessedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
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
        NSUInteger listIndex = [resources indexOfListStyle: listItem.listStyle];
        NSArray *itemNumbers = [resources incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.listStyle];
        
        NSString *markerString = [RKListStyle systemCompatibleMarker: [[listItem.listStyle markerForItemNumbers:itemNumbers] RTFEscapedString]];

        // Register the list marker
        [taggedString registerTag:[NSString stringWithFormat:@"\\ls%li\\ilvl%li {\\listtext%@}", listIndex, listItem.indentationLevel, markerString] forPosition:range.location];
    }
}

@end
