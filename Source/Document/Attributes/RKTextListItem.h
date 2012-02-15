//
//  RKTextListItem.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKTextListItemAttributeName;

/*!
 @abstract Represents an item inside a text list
 */
@interface RKTextListItem : NSObject

/*!
 @abstract Initializes a text list item as member of a text list with a certain indentation level
 @discussion Indentation level must be between 0 and 8
 */
- (id)initWithTextList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel;

/*!
 @abstract Creates a text list item as member of a text list with a certain indentation level
 @discussion Indentation level must be between 0 and 8
 */
+ (RKTextListItem *)textListItemWithTextList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel;

/*!
 @abstract A reference to the containing list
 */
@property(nonatomic,strong,readonly) RKTextList *textList;

/*!
 @abstract A reference to the indentation level used by the list
 */
@property(nonatomic,readonly) NSUInteger indentationLevel;

@end

/*!
 @abstract NSAttributedString (RKAttributedStringListItemConvenience)
 */
@interface NSAttributedString (RKAttributedStringListItemConvenience)

/*!
 @abstract Creates an attributed string containing a list item
 */
+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel;

@end

/*!
 @abstract Provides convenience methods for adding list items
 */
@interface NSMutableAttributedString (RKMutableAttributedStringListItemConvenience)

/*!
 @abstract Inserts a list item paragraph into an attributed string at a certain position
 */
- (void)insertListItem:(NSAttributedString *)text usingList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 

/*!
 @abstract Appends a list item paragraph to an attributed string
 */
- (void)appendListItem:(NSAttributedString *)text usingList:(RKTextList *)textList withIndentationLevel:(NSUInteger)indentationLevel; 

@end
