//
//  RKListEnumerator.h
//  RTFKit
//
//  Created by Friedrich Gräter on 04.04.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKListStyle, RKListItem;

/*!
 @abstract Keeps track over visted list items to provide bullet points and enumeration number of list items
 */
@interface RKListCounter : NSObject <NSCopying>

/*!
 @abstract Provides the maximum index that is used for list styles
 */
+ (NSUInteger)maximumListStyleIndex;

/*!
 @abstract Returns the index of a list
 */
- (NSUInteger)indexOfListStyle:(RKListStyle *)textList;

/*!
 @abstract Resets the item number of a list
 */
- (void)resetCounterOfList:(RKListStyle *)listStyle;

/*!
 @abstract Returns a new item number of a list level
 @discussion All item numbers for more nested list levels will be reset to the starting number of the level
 */
- (NSArray *)incrementItemNumbersForListLevel:(NSUInteger)level ofList:(RKListStyle *)textList;

/*!
 @abstract Returns the collected list styles
 @discussion A mapping from random list style numbers to RKListStyle
 */
- (NSDictionary *)listStyles;

/*!
 @abstract Increments the enumeration counters according to the indentation level of a list item and provides the appropriate marker string
 */
- (NSString *)markerForListItem:(RKListItem *)listItem;

@end
