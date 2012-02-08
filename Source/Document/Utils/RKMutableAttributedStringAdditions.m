//
//  RKAttributedStringAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 08.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKMutableAttributedStringAdditions.h"

@implementation NSMutableAttributedString (RKMutableAttributedStringAdditions)

- (void)insertListItem:(NSAttributedString *)text usingList:(RKTextList*)textList withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 
{
    NSRange range = NSMakeRange(location, text.length + 1);
    
    [self insertAttributedString:text atIndex:location];
    [self insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:location + text.length];
    
    [self addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle new] range:range];
    [self addAttribute:RKTextListItemAttributeName value:[RKTextListItem textListItemWithTextList:textList withIndentationLevel:indentationLevel] range:range];
}

- (void)appendListItem:(NSAttributedString *)text usingList:(RKTextList*)textList withIndentationLevel:(NSUInteger)indentationLevel
{
    [self insertListItem:text usingList:textList withIndentationLevel:indentationLevel atIndex:self.length];
}

@end
