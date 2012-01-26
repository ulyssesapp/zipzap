//
//  RKTypes.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
/*!
 @abstract Specifies the placement of footnotes inside a document
 */
typedef enum {
    RKFootnotePlacementSamePage     = 0,
    RKFootnotePlacementDocumentEnd  = 1,
    RKFootnotePlacementSectionEnd   = 2
} RKFootnotePlacement;

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
#define RKPointsToTwips(__points)       ((__points) * 20)

/*!
 @abstract Simple conversions from TWIPS to Points
 @see RKTwipsToPoints
 */
#define RKTwipsToPoints(__twips)        ((__twips) / 20)