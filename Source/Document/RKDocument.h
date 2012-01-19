//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
@class RKSection;

typedef enum {
    RKFootnotePlacementSamePage = 0,
    RKFootnotePlacementDocumentEnd = 1
}RKFootnotePlacement;

typedef enum {
    RKPageOrientationPortrait = 0,
    RKPageOrientationLandscape = 1
}RKPageOrientation;

/*
 @abstract Representation of an RTF document
 @discussion An RTF document is composed of multiple sections and provides settings for document formatting and meta data.
 */
@interface RKDocument : NSObject

/*!
 @abstract Exports the document as RTF with embedded pictures
 */
- (NSData*)exportAsRTF;

/*!
 @abstract Exports the document as RTFD 
 @discussion Creates a file wrapper containing the RTF and all referenced pictures
 */
- (NSFileWrapper*)exportAsRTFD;

/*!
 @abstract The sections a document consists of.
 */
@property(nonatomic, strong) NSArray *sections;

/*
 * Document Informations
 *
 */

/*!
 @abstract Document Information: Title
 */
@property(nonatomic,strong) NSString *title;

/*!
 @abstract Document Information: Copyright
 */
@property(nonatomic, strong) NSString *copyright;

/*!
 @abstract Document Information: Author
 */
@property(nonatomic, strong) NSString *author;

/*
 * Document Formatting Options
 *
 */

/*!
 @abstract Document Formatting: Hyphenation setting
 */
@property(nonatomic, getter=usesHyphenation) BOOL hyphenation;

/*!
 @abstract Document Formatting: Footnotes vs. Endnotes
 */
@property(nonatomic) RKFootnotePlacement footnotePlacement;

/*!
 @abstract Document Formatting: Page height in points
 */
@property(nonatomic) CGFloat pageHeight;

/*!
 @abstract Document Formatting: Page width in TWIPS
 */
@property(nonatomic) CGFloat pageWidth;

/*!
 @abstract Document Formatting: Paper orientation
 */
@property(nonatomic) NSPrintingOrientation pageOrientation;

/*!
 @abstract Document Formatting: Left page margin
 */
@property(nonatomic) CGFloat marginLeft;

/*!
 @abstract Document Formatting: Right page margin 
 */
@property(nonatomic) CGFloat marginRight;

/*!
 @abstract Document Formatting: Top page margin 
 */
@property(nonatomic) CGFloat marginTop;

/*!
 @abstract Document Formatting: Bottom page margin 
 */
@property(nonatomic) CGFloat marginBottom;

@end
