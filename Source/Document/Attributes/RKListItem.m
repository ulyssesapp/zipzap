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

- (instancetype)initWithStyle:(RKListStyle *)listStyle indentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex
{
    self = [self init];
    
    if (self) {
        _listStyle = listStyle;
        _indentationLevel = indentationLevel;
		_resetIndex = resetIndex;
    }

    return self;
}

- (BOOL)isEqualToListItem:(RKListItem *)other
{
    if (![other isKindOfClass: RKListItem.class])
        return NO;
    
    return [self.listStyle isEqual: other.listStyle] && (self.indentationLevel == other.indentationLevel) && (self.resetIndex == other.resetIndex);
}

- (NSUInteger)hash
{
	return 1;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"(RKTextListItem list:%@ indentationLevel:%lu resetIndex:%lu)", [self.listStyle description], (unsigned long)self.indentationLevel, (unsigned long)self.resetIndex];
}

@end

@implementation NSAttributedString (RKAttributedStringListItemConvenience)

+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: text];
	RKListItem *listItem = [[RKListItem alloc] initWithStyle:listStyle indentationLevel:indentationLevel resetIndex:resetIndex];
    
    // A trailing \n is required since a list item must be a paragraph
    if (![attributedString.string hasSuffix:@"\n"])
        [attributedString replaceCharactersInRange:NSMakeRange(attributedString.length, 0) withString:@"\n" ];
    
    [attributedString addAttribute:RKListItemAttributeName value:listItem range:NSMakeRange(0, attributedString.length)];
        
    return attributedString;
}

@end

@implementation NSMutableAttributedString (RKMutableAttributedStringAdditions)

- (void)insertListItem:(NSAttributedString *)text withStyle:(RKListStyle*)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex atIndex:(NSUInteger)location
{
    NSAttributedString *listItemString = [NSAttributedString attributedStringWithListItem:text usingStyle:listStyle withIndentationLevel:indentationLevel resetIndex:resetIndex];
    
    [self insertAttributedString:listItemString atIndex:location];
}

- (void)appendListItem:(NSAttributedString *)text withStyle:(RKListStyle*)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex
{
	[self insertListItem:text withStyle:listStyle withIndentationLevel:indentationLevel resetIndex:resetIndex atIndex:self.length];
}

@end
