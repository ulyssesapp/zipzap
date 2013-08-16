//
//  RKListItem.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKTextListItemAttributeName;

/*!
 @abstract Represents an item inside a text list
 */
@interface RKListItem : NSObject

/*!
 @abstract Initializes a text list item as member of a text list identified by a list style
 @discussion Indentation level must be between 0 and 8
 */
- (id)initWithStyle:(RKListStyle *)listStyle indentationLevel:(NSUInteger)indentationLevel;

/*!
 @abstract Creates a text list item as member of a text list identified by a list style
 @discussion Indentation level must be between 0 and 8
 */
+ (RKListItem *)listItemWithStyle:(RKListStyle *)listStyle indentationLevel:(NSUInteger)indentationLevel;

/*!
 @abstract Returns YES, if two list items use the same list style and indentation level.
 */
- (BOOL)isEqualToListItem:(RKListItem *)other;

/*!
 @abstract A reference to the list style identifying the text list
 */
@property(nonatomic,strong,readwrite) RKListStyle *listStyle;

/*!
 @abstract The indentation level used by the list
 */
@property(nonatomic,readwrite) NSUInteger indentationLevel;

@end

/*!
 @abstract NSAttributedString (RKAttributedStringListItemConvenience)
 */
@interface NSAttributedString (RKAttributedStringListItemConvenience)

/*!
 @abstract Creates an attributed string containing a list item
 */
+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel;

@end

/*!
 @abstract Provides convenience methods for adding list items
 */
@interface NSMutableAttributedString (RKMutableAttributedStringListItemConvenience)

/*!
 @abstract Inserts a list item paragraph into an attributed string at a certain position
 */
- (void)insertListItem:(NSAttributedString *)text withStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 

/*!
 @abstract Appends a list item paragraph to an attributed string
 */
- (void)appendListItem:(NSAttributedString *)text withStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel; 

@end
