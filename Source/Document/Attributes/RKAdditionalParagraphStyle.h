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

@end
