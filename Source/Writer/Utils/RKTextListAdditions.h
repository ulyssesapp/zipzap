//
//  RKTextListAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 RTF marker codes for \levelnfcN tag supported by NSTextList
 */
typedef enum {
    RKTextListMarkerDecimal             = 0,
    RKTextListMarkerUpperCaseRoman      = 1,
    RKTextListMarkerLowerCaseRoman      = 2,
    RKTextListMarkerUpperCaseLetter     = 3,
    RKTextListMarkerLowerCaseLetter     = 4,
    RKTextListMarkerBullet              = 23,
    RKTextListMarkerNone                = 255
} RKTextListMarkerCode;

/*!
 @abstract NSTextList additions for converting and instantiating markers to RTF
 */
@interface NSTextList (RKTextListAdditions)

/*!
 @abstract Returns the RTF marker type of the marker format string of an NSTextList
 */
- (RKTextListMarkerCode)RTFMarkerCode;

@end
