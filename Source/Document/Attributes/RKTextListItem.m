//
//  RKTextList.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListItem.h"

@implementation RKTextListItem

@synthesize textList, indentationLevel;

- (id)initWithTextList:(RKTextList *)initialTextList withIndentationLevel:(NSUInteger)initialIndentationLevel
{
    self = [self init];
    
    if (self) {
        textList = initialTextList;
        indentationLevel = initialIndentationLevel;
    }

    return self;
}

+ (RKTextListItem *)textListItemWithTextList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel
{
    return [[RKTextListItem alloc] initWithTextList:textList withIndentationLevel:indentationLevel];
}

@end
