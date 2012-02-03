//
//  RKTextListItem.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKTextListItemAttributeName;

@class RKTextListItem;

@interface RKTextListItem : NSObject

/*!
 @abstract A reference to the containing list
 */
@property(strong,nonatomic,readwrite) RKTextList *textList;

/*!
 @abstract A reference to the indentation level used by the list
 */
@property(nonatomic) NSUInteger *indentationLevel;

@end
