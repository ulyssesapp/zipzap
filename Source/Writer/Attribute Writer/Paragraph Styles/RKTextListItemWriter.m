//
//  RKTextListItemWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListItemWriter.h"
#import "RKAttributedStringWriter.h"
#import "RKTextListItem.h"
#import "RKTextListWriterAdditions.h"

@implementation RKTextListItemWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:RKTextListItemAttributeName withPriority:RKAttributedStringWriterPriorityParagraphStylingLevel];
}

+ (void)addTagsForAttribute:(RKTextListItem *)listItem
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (listItem) {
        NSUInteger listIndex = [resources indexOfList:listItem.textList];
        NSArray *itemNumbers = [resources incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.textList];
        
        NSString *markerString = [listItem.textList markerForItemNumbers:itemNumbers];
        
        // Note: the tabulators enclosing the listtext content are required for compatability to the text system
        [taggedString registerTag:[NSString stringWithFormat:@"\\ls%i\\ilvl%i {\\listtext%@}", listIndex + 1, listItem.indentationLevel, markerString] forPosition:range.location];
    }
}

@end
