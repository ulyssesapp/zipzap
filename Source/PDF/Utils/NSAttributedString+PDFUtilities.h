//
//  NSAttributedString+PDFUtilities.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Utility methods for PDF generation
 */
@interface NSAttributedString (PDFUtilities)

/*!
 @abstract Creates a new attributed string from the current string by applying the footnote style using a footnote index.
 */
- (NSAttributedString *)attributedStringByApplyingFootnoteStyle:(RKFootnoteEnumerationStyle *)enumerationStyle index:(NSUInteger)footnoteIndex;

/*!
 @abstract Creates an attributed string containing the given footnotes
 @discussion Each footnote is represented by an NSAttributedString. The array index is used as index offset for each footnote.
 */
+ (NSAttributedString *)attributedStringWithFootnotes:(NSArray *)footnotes enumerationStyle:(RKFootnoteEnumerationStyle *)enumerationStyle startIndex:(NSUInteger)startIndex;

@end
