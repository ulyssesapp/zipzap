//
//  RKAttributedStringAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSAttributedString (RKAttributedStringAdditions)

/*!
 @abstract Determines the current line height
 */
- (CGFloat)pointSizeInRange:(NSRange)range;

@end
