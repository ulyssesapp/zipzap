//
//  RKPredefinedStyle.h
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
@interface NSMutableAttributedString (RKAttributedStringPredefinedStyleConvenience)

/*!
 @abstract Adds a predefined character style to a range
 */
- (void)addPredefinedCharacterStyleAttribute:(NSString *)styleSheetName range:(NSRange)range;

/*!
 @abstract Adds a predefined paragraph style to a range
 */
- (void)addPredefinedParagraphStyleAttribute:(NSString *)styleSheetName range:(NSRange)range;

/*!
 @abstract Adds a predefined character style to a range and applies its formating rules
 */
- (void)applyPredefinedCharacterStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range;

/*!
 @abstract Adds a predefined paragraph style to a range and applies its formating rules
 */
- (void)applyPredefinedParagraphStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range;

@end
