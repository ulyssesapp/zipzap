//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import <RKTypes.h>

@class RKSection;

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

#pragma mark -META DATA

/*!
 @abstract Document title
 */
@property(nonatomic, strong) NSString *title;

/*!
 @abstract Copyright information
 */
@property(nonatomic, strong) NSString *copyright;

/*!
 @abstract Document author
 */
@property(nonatomic, strong) NSString *author;

#pragma mark -FORMATTING

/*!
 @abstract Specifies whether hyphenation is enabled in this document.
 */
@property(nonatomic) BOOL hyphenationEnabled;

/*!
 @abstract Specifies the placement of footnotes within the document
 */
@property(nonatomic) RKFootnotePlacement footnotePlacement;

/*!
 @abstract Page height in points
 */
@property(nonatomic) CGFloat pageHeight;

/*!
 @abstract Page width in points
 */
@property(nonatomic) CGFloat pageWidth;

/*!
 @abstract Page insets in points
 */
@property(nonatomic) RKPageInsets pageInsets;

/*!
 @abstract Page orientation
 */
@property(nonatomic) RKPageOrientation pageOrientation;



@end
