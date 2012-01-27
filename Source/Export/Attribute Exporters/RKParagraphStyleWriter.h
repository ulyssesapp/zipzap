//
//  RKParagraphStyleWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKTaggedString;

/*!
 @abstract Writes out all tags required for a paragraph style
 */
@interface RKParagraphStyleWriter : NSObject

/*!
 @abstract Adds tags for all paragraph styles
 */
+ (void)tagParagraphStyles:(RKTaggedString *)taggedString fromAttributedString:(NSAttributedString *)attributedString;

@end
