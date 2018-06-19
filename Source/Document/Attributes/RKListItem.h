//
//  RKListItem.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract The attribute name used for referencing list items within an attributed string.
 */
extern NSString *RKListItemAttributeName;

/*!
 @abstract Represents an item inside a text list
 @discussion References by a RKListItemAttributeName inside the attributed string.
 */
@interface RKListItem : NSObject

/*!
 @abstract Initializes a text list item as member of a text list identified by a list style
 @discussion Indentation level must be between 0 and 8. The list item can reset the current enumeration index to the given value, if it has a value different from NSUIntegerMax.
 */
- (instancetype)initWithStyle:(RKListStyle *)listStyle indentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex;

/*!
 @abstract Returns YES, if two list items use the same list style and indentation level.
 */
- (BOOL)isEqualToListItem:(RKListItem *)other;

/*!
 @abstract A reference to the list style identifying the text list
 */
@property(nonatomic,strong) RKListStyle *listStyle;

/*!
 @abstract The indentation level used by the list
 */
@property(nonatomic) NSUInteger indentationLevel;

/*!
 @abstract An index that should reset the enumeration index for the current list item (and all subsequent items).
 @discussion Will be ignored if set to NSUIntegerMax.
 */
@property(nonatomic) NSUInteger resetIndex;

@end

/*!
 @abstract NSAttributedString (RKAttributedStringListItemConvenience)
 */
@interface NSAttributedString (RKAttributedStringListItemConvenience)

/*!
 @abstract Creates an attributed string containing a list item
 */
+ (NSAttributedString *)attributedStringWithListItem:(NSAttributedString *)text usingStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex;

@end

/*!
 @abstract Provides convenience methods for adding list items
 */
@interface NSMutableAttributedString (RKMutableAttributedStringListItemConvenience)

/*!
 @abstract Inserts a list item paragraph into an attributed string at a certain position
 */
- (void)insertListItem:(NSAttributedString *)text withStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex atIndex:(NSUInteger)location;

/*!
 @abstract Appends a list item paragraph to an attributed string
 */
- (void)appendListItem:(NSAttributedString *)text withStyle:(RKListStyle *)listStyle withIndentationLevel:(NSUInteger)indentationLevel resetIndex:(NSUInteger)resetIndex; 

@end
