//
//  RKSection.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RKEndNotesAtDocumentEnd = 0,
    RKEndNotesAtSectionEnd = 1
}RKEndNotePlacement;

typedef enum {
    RKDecimalPageNumbering = 0,
    RKLowerCaseRomanPageNumbering = 1,
    RKUpperCaseRomanPageNumbering = 2,
    RKLowerCaseAlphabeticPageNumbering = 3,
    RKUpperCaseAlphabeticPageNumbering = 4
}RKPageNumberingStyle;

typedef enum {
    RKLeftToRightTopToBottom = 0,
    RKRightToLeftTopToBottom = 1,
    RKTopToBottomLeftToRight = 2,
    RKBottomToTopLeftToRight = 3,
    RKTopToBottomRightToLeft = 4,
    RKBottomToTopRightToLeft = 5
}RKTextOrientation;

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

/*
 @abstract Text orientation
 */
@property(readwrite) RKTextOrientation textOrientation;

@end
