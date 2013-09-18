//
//  RKAdditionalParagraphStyle.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKAdditionalParagraphStyleAttributeName;

/*!
 @abstract Stores additional paragraph styling information that are beyond the capabilities of NSParagraphStyle
 */
@interface RKAdditionalParagraphStyle : NSObject

/*!
 @abstract Specifies, whether the paragraph should be kept together with the following paragraph
 @discussion Default: NO
 */
@property (nonatomic) BOOL keepWithFollowingParagraph;

/*!
 @abstract Specifies that the current paragraph should be hyphenated.
 */
@property (nonatomic) BOOL hyphenationEnabled;

/*!
 @abstract The distance between the two base lines of a paragraph.
 @discussion Only used if "overrideLineHeightAndSpacing" is set to YES. In this case, line height and spacing settings of NSParagraph will be ignored. For RTF export, this setting may be recalculated to a relative value.
 */
@property (nonatomic) CGFloat baseLineDistance;

/*!
 @abstract Specifies that the line height should be calculated from -baseLineDistance rather from NSParagraph's line height settings.
 */
@property (nonatomic) BOOL overrideLineHeightAndSpacing;
 

@end
