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

@property(nonatomic, strong) NSAttributedString *content;

/*
  @abstract Header
 */
@property(nonatomic, strong) NSAttributedString *header;

/*
 @abstract Footer
 */
@property(nonatomic, strong) NSAttributedString *footer;

/*
 @abstract Header (front page)
 */
@property(nonatomic, strong) NSAttributedString *headerFrontPage;

/*
 @abstract Footer (front page)
 */
@property(nonatomic, strong) NSAttributedString *footerFrontPage;

/*
 @abstract Header (left page)
 */
@property(nonatomic, strong) NSAttributedString *headerLeftPage;

/*
 @abstract Footer (left page)
 */
@property(nonatomic, strong) NSAttributedString *footerLeftPage;

/*
 @abstract Header (right page)
 */
@property(nonatomic, strong) NSAttributedString *headerRightPage;

/*
 @abstract Footer (right page)
 */
@property(nonatomic, strong) NSAttributedString *footerRightPage;

/*
 @abstract Endnote placement
 */
@property(nonatomic) RKEndnotePlacement endnotes;

/*
 @abstract Multicolumn layout
 */
@property(nonatomic) NSInteger columnCount;

/*
 @abstract Starting page number
 */
@property(nonatomic) NSInteger startingPageNumber;

/*
 @abstract Page number style
 */
@property(nonatomic) RKPageNumberingStyle pageNumberingStyle;


@end
