//
//  RKStyleName.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Attribute referencing the name of character styles.
 @discussion In order to be exported properly, the character style must be defined in RKDocument. Use RKDefaultStyleName to specify that the default style shall be used.
 */
extern NSString *RKCharacterStyleNameAttributeName;

/*!
 @abstract Attribute referencing the name of paragraph styles.
 @discussion In order to be exported properly, the paragraph style must be defined in RKDocument. Use RKDefaultStyleName to specify that the default style shall be used.
 */
extern NSString *RKParagraphStyleNameAttributeName;

/*!
 @abstract The name of the default style.
 */
extern NSString *RKDefaultStyleName;

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
