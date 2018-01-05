//
//  RKPlaceholder.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Possible placeholders
 @const
    RKPlaceholderPageNumber        The placeholder should be substituted by the current page number (\chpgn)
    RKPlaceholderSectionNumber     The placeholder should be substituted by the current section number (\sectnum)
*/
typedef enum : NSUInteger {
    RKPlaceholderPageNumber         = 1,
    RKPlaceholderSectionNumber      = 2
} RKPlaceholderType;

extern NSString *RKPlaceholderAttributeName;

/*!
 @abstract Provides convenience methods for creating placehoders
 */
@interface NSAttributedString (RKAttributedStringPlaceholderConvenience)

/*!
 @abstract Creates an attributed string containing a placeholder
 */
+ (NSAttributedString *)attributedStringWithPlaceholder:(RKPlaceholderType)placeholder;

@end
