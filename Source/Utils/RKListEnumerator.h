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
@interface RKListEnumerator : NSObject

/*!
 @abstract Resets the enumeration counters for a certain list identified by its list style
 */
- (void)resetCounterOfList:(RKListStyle *)listStyle;

/*!
 @abstract Increments the enumeration counters according to the indentation level of a list item and provides the appropriate marker string
 */
- (NSString *)markerForListItem:(RKListItem *)listItem;

@end
