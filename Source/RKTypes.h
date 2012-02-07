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
typedef enum {
    RKFootnotePlacementSamePage                 = 0,
    RKFootnotePlacementSectionEnd               = 1,
    RKFootnotePlacementDocumentEnd              = 2
} RKFootnotePlacement;

/*!
 @abstract Specifies the placement of endnotes inside a document
 */
typedef enum {
    RKEndnotePlacementDocumentEnd              = 0,
    RKEndnotePlacementSectionEnd               = 1
} RKEndnotePlacement;

/*!
 @abstract Specifies the orientation of a page
 */
typedef enum {
    RKPageOrientationPortrait   = 0,
    RKPageOrientationLandscape  = 1
} RKPageOrientation;

/*!
 @abstract Specifies the insets of a page
 */
typedef struct {
    CGFloat top, left, bottom, right;
} RKPageInsets;


/*!
 @abstract Generates the insets of a page
 */
#define RKPageInsetsMake(__top, __left, __right, __bottom)      ((RKPageInsets){.top = __top, .left = __left, .right = __right, .bottom = __bottom})

/*!
 @abstract Specifies the style of page numbering inside a section
 */
typedef enum {
    RKPageNumberingDecimal              = 0,
    RKPageNumberingRomanLowerCase       = 1,
    RKPageNumberingRomanUpperCase       = 2,
    RKPageNumberingAlphabeticLowerCase  = 3,
    RKPageNumberingAlphabeticUpperCase  = 4
} RKPageNumberingStyle;

/*!
 @abstract Specifies the style of footnote numbering inside a section
 */
typedef enum {
    RKFootnoteEnumerationDecimal                    = 0,
    RKFootnoteEnumerationAlphabeticLowerCase        = 1,
    RKFootnoteEnumerationAlphabeticUpperCase        = 2,
    RKFootnoteEnumerationRomanLowerCase             = 3,
    RKFootnoteEnumerationRomanUpperCase             = 4,
    RKFootnoteEnumerationChicagoManual              = 5
}RKFootnoteEnumerationStyle;

/*!
 @abstract Options for restarting footnote enumeration
 */
typedef enum {
    RKFootnoteRestartEnumerationOnEachPage          = 0,
    RKFootnoteRestartEnumerationOnEachSection       = 1,
    RKFootnoteContinuousEnumerationInDocument       = 2
}RKFootnoteEnumerationPolicy;

/*!
 @abstract Possible selections for page headers and footers
 */
typedef enum {
    RKPageSelectionLeft  = 1<<0,
    RKPageSelectionRight = 1<<1,
    RKPageSelectionFirst = 1<<2,
    
    RKPageSelectorAll  = 0xFFFF
}RKPageSelectionMask;

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
 @abstract Special RTF characters
 */
typedef enum {
    RKSpecialCharacterNewPage       = '\f',
    RKSpecialCharacterTab           = '\t',
}RKSpecialCharacters;
