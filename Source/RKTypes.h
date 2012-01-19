//
//  RKTypes.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#ifndef RTFKit_RKTypes_h
#define RTFKit_RKTypes_h

/*
 * @abstract Specifies the placement of footnotes inside a document
 *
 */
typedef enum {
    RKFootnotePlacementSamePage = 0,
    RKFootnotePlacementDocumentEnd = 1
}RKFootnotePlacement;

/*
 * @abstract Specifies the orientation of a page
 *
 */
typedef enum {
    RKPageOrientationPortrait = 0,
    RKPageOrientationLandscape = 1
}RKPageOrientation;

/*
 * @abstract Specifies the insets of a page
 *
 */
typedef struct {
    CGFloat top, left, bottom, right;
} RKPageInsets;

/*
 * @abstract Specifies the placement of endnotes inside a section
 *
 */
typedef enum {
    RKEndnotesPlacementDocumentEnd = 0,
    RKEndnotesPlacementSectionEnd = 1
}RKEndnotePlacement;

/*
 * @abstract Specifies the style of page numbering inside a section
 *
 */
typedef enum {
    RKPageNumberingDecimal = 0,
    RKPageNumberingRomanLowerCase = 1,
    RKPageNumberingRomanUpperCase = 2,
    RKPageNumberingAlphabeticLowerCase = 3,
    RKPageNumberingAlphabeticUpperCase = 4
}RKPageNumberingStyle;

#endif
