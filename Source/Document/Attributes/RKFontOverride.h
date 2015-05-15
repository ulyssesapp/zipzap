//
//  RKFontOverride.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract Properties of RKFontAttribute which shall be ignored when creating a style template.
 @discussion The RKFontOverrideAttribute needs to be stored in the same dictionary as the affiliated RKFontAttribute.
 
 @const RKFontOverrideItalicTrait The font attribute’s italic trait shall be ignored when mixing two styles.
 @const RKFontOverrideBoldTrait The font attribute’s bold trait shall be ignored when mixing two styles.
 @const RKFontOverrideFontName The font attribute’s font name shall be ignored when mixing two styles.
 @const RKFontOverrideFontSize The font attribute’s font size shall be ignored when mixing two styles.
 */
typedef enum : NSUInteger {
	RKFontOverrideItalicTrait	= 1 << 0,
	RKFontOverrideBoldTrait		= 1 << 1,
	RKFontOverrideFontName		= 1 << 2,
	RKFontOverrideFontSize		= 1 << 3,
} RKFontOverrideMask;

extern NSString *RKFontOverrideAttributeName;

#define RKFontOverrideAll		(RKFontOverrideFontName & RKFontOverrideFontSize & RKFontOverrideItalicTrait & RKFontOverrideBoldTrait)

@interface RKFontOverride : NSObject

@end
