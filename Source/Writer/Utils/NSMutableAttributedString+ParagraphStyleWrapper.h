//
//  NSMutableAttributedString+ParagraphStyleWrapper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

@class RKParagraphStyleWrapper;

/*!
 @abstract Methods used for updating paragraph styles in a plattform-independend way.
 */
@interface NSMutableAttributedString (ParagraphStyleWrapper)

/*!
 @abstract Provides an portable paragraph style for the given index.
 */
- (RKParagraphStyleWrapper *)wrappedParagraphStyleAtIndex:(NSUInteger)index;

/*!
 @abstract Updates an existing paragraph style inside the given text range. The block will receive a plattform-independent, mutable paragraph style wrapper. Modifications on this wrapper will be re-submitted to the attributed string, either as CTParagraphStyle or NSParagraphStyle.
 */
- (void)updateParagraphStylesInRange:(NSRange)range usingBlock:(void(^)(NSRange range, RKParagraphStyleWrapper *paragraphStyle))block;

@end
