//
//  RKTextStyle.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKPredefinedCharacterStyleAttributeName;
extern NSString *RKPredefinedParagraphStyleAttributeName;

@class RKTextStyleSheet;

/*!
 @abstract Provides convenience methods for setting paragraph and character styles
 */
@interface NSMutableAttributedString (RKAttributedStringTextStyleConvenience)

/*!
 @abstract Adds a predefined character style to a range
 */
- (void)addCharacterStyleAttribute:(NSString *)styleSheetName range:(NSRange)range;

/*!
 @abstract Adds a predefined paragraph style to a range
 */
- (void)addParagraphStyleAttribute:(NSString *)styleSheetName range:(NSRange)range;

@end
