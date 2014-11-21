//
//  RKListItem.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItem.h"

NSString *RKListItemAttributeName = @"RKTextListItem";

@implementation RKListItem

- (id)initWithStyle:(RKListStyle *)initialListStyle indentationLevel:(NSUInteger)initialIndentationLevel
{
    self = [self init];
    
    if (self) {
        _listStyle = initialListStyle;
        _indentationLevel = initialIndentationLevel;
    }

    return self;
}

+ (RKListItem *)listItemWithStyle:(RKListStyle *)listStyle indentationLevel:(NSUInteger)indentationLevel
{
    return [[RKListItem alloc] initWithStyle:listStyle indentationLevel:indentationLevel];
}

- (BOOL)isEqualToListItem:(RKListItem *)other
{
    if (![other isKindOfClass: RKListItem.class])
        return NO;
    
    return [self.listStyle isEqual: other.listStyle] && (self.indentationLevel == other.indentationLevel);
}

- (NSUInteger)hash
{
	return 1;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(RKTextListItem list:%@ indentationLevel:%lu)", [self.listStyle description], self.indentationLevel];
}

@end

@implementation NSAttributedString (RKAttributedStringListItemConvenience)

+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: text];
    RKListItem *listItem = [RKListItem listItemWithStyle:listStyle indentationLevel:indentationLevel];
    
    // A trailing \n is required since a list item must be a paragraph
    if (![attributedString.string hasSuffix:@"\n"])
        [attributedString replaceCharactersInRange:NSMakeRange(attributedString.length, 0) withString:@"\n" ];
    
    [attributedString addAttribute:RKListItemAttributeName value:listItem range:NSMakeRange(0, attributedString.length)];
        
    return attributedString;
}

@end

@implementation NSMutableAttributedString (RKMutableAttributedStringAdditions)

- (void)insertListItem:(NSAttributedString *)text withStyle:(RKListStyle*)listStyle withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 
{
    NSAttributedString *listItemString = [NSAttributedString attributedStringWithListItem:text usingStyle:listStyle withIndentationLevel:indentationLevel];
    
    [self insertAttributedString:listItemString atIndex:location];
}

- (void)appendListItem:(NSAttributedString *)text withStyle:(RKListStyle*)listStyle withIndentationLevel:(NSUInteger)indentationLevel
{
    [self insertListItem:text withStyle:listStyle withIndentationLevel:indentationLevel atIndex:self.length];
}

@end
