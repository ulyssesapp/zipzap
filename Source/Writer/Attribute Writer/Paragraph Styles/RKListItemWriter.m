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

@implementation RKListItemWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:RKTextListItemAttributeName priority:RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel];
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
        
        NSString *markerString = [RKListStyle systemCompatibleMarker: [listItem.listStyle markerForItemNumbers:itemNumbers]];

        [taggedString registerTag:[NSString stringWithFormat:@"\\ls%i\\ilvl%i {\\listtext%@}", listIndex + 1, listItem.indentationLevel, markerString] forPosition:range.location];
    }
}

@end
