//
//  RKInlineStyleWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKTaggedString, RKResourcePool;

/*!
 @abstract Writes out all tags required for font styles
 */
@interface RKInlineStyleWriter : NSObject

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tag:(RKTaggedString *)taggedString withFontStylesOfAttributedString:(NSAttributedString *)attributedString resources:(RKResourcePool *)resources;


@end
