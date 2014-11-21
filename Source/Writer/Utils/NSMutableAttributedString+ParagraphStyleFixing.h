//
//  NSMutableAttributedString+ParagraphStyleFixing.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

/*!
 @abstract Methods used for updating paragraph styles in a plattform-independend way.
 */
@interface NSMutableAttributedString (ParagraphStyleFixing)

/*!
 @abstract Iterates over all paragraphs in the given range and updates all paragraph styles using the given block.
 @discussion Changes in the passed paragraph style will be written back. 
 */
- (void)updateParagraphStylesInRange:(NSRange)range usingBlock:(void(^)(NSRange range, NSMutableParagraphStyle *paragraphStyle))block;

@end
