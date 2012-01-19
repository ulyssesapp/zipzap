//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKSection;

typedef enum {
    RKFootNotes = 0,
    RKEndNotes = 1
}RKFootNotePlacement;

typedef enum {
    RKPortrait = 0,
    RKLandscape = 1,
}RKDocumentOrientation;

@interface RKDocument : NSObject

/*!
 @abstract Adds a further text section to the document.
 */
- (void)addSection: (RKSection*)section;

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
@property(strong,readonly) NSArray *sections;

/*
 * Document Informations
 *
 */

/*!
 @abstract Document Information: Title
 */
@property(strong,readwrite) NSString *title;

/*!
 @abstract Document Information: Copyright
 */
@property(strong,readwrite) NSString *copyright;

/*!
 @abstract Document Information: Author
 */
@property(strong,readwrite) NSString *author;

/*
 * Document Formatting Options
 *
 */

/*!
 @abstract Document Formatting: Hyphenation setting
 */
@property(readwrite, getter=usesHyphenation) BOOL hyphenation;

/*!
 @abstract Document Formatting: Footnotes vs. Endnotes
 */
@property(readwrite) RKFootNotePlacement footnotePlacement;

/*!
 @abstract Document Formatting: Paper height in TWIPS
 */
@property(readwrite) CGFloat paperHeight;

/*!
 @abstract Document Formatting: Paper width in TWIPS
 */
@property(readwrite) CGFloat paperWidth;

/*!
 @abstract Document Formatting: Paper orientation
 */
@property(readwrite) RKDocumentOrientation paperOrientation;

/*!
 @abstract Document Formatting: Left page margin
 */
@property(readwrite) CGFloat marginLeft;

/*!
 @abstract Document Formatting: Right page margin 
 */
@property(readwrite) CGFloat marginRight;

/*!
 @abstract Document Formatting: Top page margin 
 */
@property(readwrite) CGFloat marginTop;

/*!
 @abstract Document Formatting: Bottom page margin 
 */
@property(readwrite) CGFloat marginBottom;

@end
