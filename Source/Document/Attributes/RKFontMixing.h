//
//  RKFontMixing.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract Specifies which properties of RKFontAttributeName should be ignored when mixing two attribute dictionaries.
 @discussion Used as attribute value for RKFontMixAttributeName.
 
 @const RKFontMixIgnoreFontName		The font attribute’s font name shall be ignored when mixing two styles.
 @const RKFontMixIgnoreFontSize		The font attribute’s font size shall be ignored when mixing two styles.
 @const RKFontMixIgnoreBoldTrait	The font attribute’s bold trait shall be ignored when mixing two styles.
 @const RKFontMixIgnoreItalicTrait	The font attribute’s italic trait shall be ignored when mixing two styles.
 */
typedef enum : NSUInteger {
	RKFontMixIgnoreFontName		= 1 << 0,
	RKFontMixIgnoreFontSize		= 1 << 1,
	RKFontMixIgnoreBoldTrait	= 1 << 2,
	RKFontMixIgnoreItalicTrait	= 1 << 3,
} RKFontMixMask;

/*!
 @abstract Attribute used in character style templtes to specify which font properties (RKFontAttributeName) of an attribute dictionary should be ignored when mixing it with the font settings of another attribute dictionary.
 @discussion If this attribute is set to 0 or if the attribute is missing, the character style’s font is completely overriding the font of the paragraph style template.
 
 To give an example: If a character style template only specifies that its font should be bold, but should reuse the font name and size of the underlying paragraph style template, it must set the following flags: RKFontMixIgnoreFontName, RKFontMixIgnoreFontSize, RKFontMixIgnoreItalicTrait.
 */
extern NSString *RKFontMixAttributeName;

#define RKFontMixIgnoreAll	(RKFontMixIgnoreFontName | RKFontMixIgnoreFontSize | RKFontMixIgnoreBoldTrait | RKFontMixIgnoreItalicTrait)
