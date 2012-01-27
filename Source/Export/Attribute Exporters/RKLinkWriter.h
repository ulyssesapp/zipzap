//
//  RKLinkWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKTaggedString;

/*!
 @abstract Writes out all tags required for a link style
 */
@interface RKLinkWriter : NSObject

/*!
 @abstract Adds tags for all link styles
 */
+ (void)tag:(RKTaggedString *)taggedString withLinkStylesOfAttributedString:(NSAttributedString *)attributedString;


@end
