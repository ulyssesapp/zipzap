//
//  RKTextPlaceholder.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Possible placeholders
 @const
    RKTextPlaceholderPageNumber        The placeholder should be substituted by the current page number (\chpgn)
    RKTextPlaceholderSectionNumber     The placeholder should be substituted by the current section number (\sectnum)
*/
 typedef enum {
    RKTextPlaceholderPageNumber         = 0,
    RKTextPlaceholderSectionNumber      = 1
}RKTextPlaceholderType;

extern NSString *RKTextPlaceholderAttributeName;

/*!
 @abstract Represents a certain variable content
 @discussion e.g. Page numbers, Section numbers
 */
@interface RKTextPlaceholder : NSObject

/*!
 @abstract Creates a new placeholder with a certain placeholder type
 */
+ (RKTextPlaceholder*)placeholderWithType:(RKTextPlaceholderType)placeholderType;

/*!
 @abstract Initializes a placeholder with a certain placeholder type
 */
- (id)initWithPlaceholderType:(RKTextPlaceholderType)placeholderType;

/*!
 @abstract The type of the placeholder
 */
@property(nonatomic) RKTextPlaceholderType placeholderType;

@end
