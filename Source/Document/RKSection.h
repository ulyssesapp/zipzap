//
//  RKSection.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
typedef enum {
    RKEndnotesPlacementDocumentEnd = 0,
    RKEndnotesPlacementSectionEnd = 1
}RKEndnotePlacement;

typedef enum {
    RKPageNumberingDecimal = 0,
    RKPageNumberingRomanLowerCase = 1,
    RKPageNumberingRomanUpperCase = 2,
    RKPageNumberingAlphabeticLowerCase = 3,
    RKPageNumberingAlphabeticUpperCase = 4
}RKPageNumberingStyle;

/*
 @abstract Representation of an RTF section
 @discussion An RTF section is an area of the document that has own headlines, footers and custom layouting options.
 */
@interface RKSection : NSObject

- (id)initWithContent:(NSAttributedString*)content;

@property(strong,readwrite) NSAttributedString *content;

/*
  @abstract Header
 */
@property(strong,readwrite) NSAttributedString *header;

/*
 @abstract Footer
 */
@property(strong,readwrite) NSAttributedString *footer;

/*
 @abstract Header (front page)
 */
@property(strong,readwrite) NSAttributedString *headerFrontPage;

/*
 @abstract Footer (front page)
 */
@property(strong,readwrite) NSAttributedString *footerFrontPage;

/*
 @abstract Header (left page)
 */
@property(strong,readwrite) NSAttributedString *headerLeftPage;

/*
 @abstract Footer (left page)
 */
@property(strong,readwrite) NSAttributedString *footerLeftPage;

/*
 @abstract Header (right page)
 */
@property(strong,readwrite) NSAttributedString *headerRightPage;

/*
 @abstract Footer (right page)
 */
@property(strong,readwrite) NSAttributedString *footerRightPage;

/*
 @abstract Endnote placement
 */
@property(readwrite) RKEndNotePlacement endnotes;

/*
 @abstract Multicolumn layout
 */
@property(readwrite) NSInteger columnCount;

/*
 @abstract Starting page number
 */
@property(readwrite) NSInteger startingPageNumber;

/*
 @abstract Page number style
 */
@property(readwrite) RKPageNumberingStyle pageNumberingStyle;


@end
