//
//  RKFootnote.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKFootnoteAttributeName;
extern NSString *RKEndnoteAttributeName;

/*!
 @abstract Provides convenience methods for creating footnotes and endnotes
 */
@interface NSAttributedString (RKAttributedStringFootnoteConvenience)

/*!
 @abstract Creates an attributed string containing a footnote
 */
+ (NSAttributedString *)attributedStringWithFootnote:(NSAttributedString *)footnote;

/*!
 @abstract Creates an attributed string containing an endnote
 */
+ (NSAttributedString *)attributedStringWithEndnote:(NSAttributedString *)endnote;

@end
