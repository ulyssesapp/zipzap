//
//  RKTypes.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Specifies the usage of footnotes and endnotes
 */
typedef enum : NSUInteger {
    RKFootnotePlacementSamePage                 = 0,
    RKFootnotePlacementSectionEnd               = 1,
    RKFootnotePlacementDocumentEnd              = 2
} RKFootnotePlacement;

/*!
 @abstract Specifies the placement of endnotes inside a document
 */
typedef enum : NSUInteger {
    RKEndnotePlacementDocumentEnd              = 0,
    RKEndnotePlacementSectionEnd               = 1
} RKEndnotePlacement;

/*!
 @abstract Specifies the orientation of a page
 */
typedef enum : NSUInteger {
    RKPageOrientationPortrait   = 0,
    RKPageOrientationLandscape  = 1
} RKPageOrientation;

/*!
 @abstract Specifies the insets of a page
 */
typedef struct {
    CGFloat top, inner, bottom, outer;
} RKPageInsets;


/*!
 @abstract Generates the insets of a page
 */
#define RKPageInsetsMake(__top, __inner, __outer, __bottom)      ((RKPageInsets){.top = __top, .inner = __inner, .outer = __outer, .bottom = __bottom})

/*!
 @abstract Specifies the style of page numbering inside a section
 */
typedef enum : NSUInteger {
    RKPageNumberingDecimal              = 0,
    RKPageNumberingRomanLowerCase       = 1,
    RKPageNumberingRomanUpperCase       = 2,
    RKPageNumberingAlphabeticLowerCase  = 3,
    RKPageNumberingAlphabeticUpperCase  = 4
} RKPageNumberingStyle;

/*!
 @abstract Specifies the style of footnote numbering inside a section
 */
typedef enum : NSUInteger {
    RKFootnoteEnumerationDecimal                    = 0,
    RKFootnoteEnumerationAlphabeticLowerCase        = 1,
    RKFootnoteEnumerationAlphabeticUpperCase        = 2,
    RKFootnoteEnumerationRomanLowerCase             = 3,
    RKFootnoteEnumerationRomanUpperCase             = 4,
    RKFootnoteEnumerationChicagoManual              = 5
} RKFootnoteEnumerationStyle;

/*!
 @abstract Options for restarting footnote enumeration
 */
typedef enum : NSUInteger {
    RKFootnoteEnumerationPerPage          = 0,
    RKFootnoteEnumerationPerSection       = 1,
    RKFootnoteContinuousEnumeration       = 2
} RKFootnoteEnumerationPolicy;

/*!
 @abstract Possible selections for page headers and footers
 */
typedef enum : NSUInteger {
    RKPageSelectionLeft  = 1<<0,
    RKPageSelectionRight = 1<<1,
    RKPageSelectionFirst = 1<<2,
    
    RKPageSelectorAll  = 0xFFFF
} RKPageSelectionMask;

/*!
 @abstract Possible page pinding types.
 
 @const RKPageBindingLeft			Page binding on the left side. On single-sided printing, the inner margin will be on the right side. On double-sided printing, the first pages are placed on the right side.
 @const RKPageBindingRight			Page binding on the right side. On single-sided printing, the inner margin will be on the left side. On double-sided printing, the first pages are placed on the left side.
 */
typedef enum : NSUInteger {
	RKPageBindingLeft = 0,
	RKPageBindingRight
} RKPageBindingPosition;

/*!
 @abstract Simple conversions from Points to TWIPS
 @discussion (1 TWIP = 1 / 20 Point = 1 / 1440 inch)
 */
#define RKPointsToTwips(__points)       ((__points) * (typeof(__points))20)

/*!
 @abstract Simple conversions from TWIPS to Points
 @see RKTwipsToPoints
 */
#define RKTwipsToPoints(__twips)        ((__twips) / (typeof(__twips))20)

/*!
 @abstract The character used to indicate hyphenation
*/
#define RKSoftHyphenCharacter			((unichar)0xAD)

/*!
 @abstract Platform-agnostic version of NSEdgeInsets
 */
#if TARGET_OS_IPHONE
	#define RKEdgeInsets		UIEdgeInsets
	#define RKEdgeInsetsMake	UIEdgeInsetsMake
#else
	#define RKEdgeInsets		NSEdgeInsets
	#define RKEdgeInsetsMake	NSEdgeInsetsMake
#endif

