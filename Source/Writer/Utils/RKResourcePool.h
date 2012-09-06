//
//  RKResourcePool.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument, RKListStyle, RKListCounter;

/*!
 @abstract Manages files, font and color definitions from an RKDocument
 */
@interface RKResourcePool : NSObject

/*!
 @abstract Initializes the resource pool with a certain document
 */
- (id)initWithDocument:(RKDocument *)document;

/*!
 @abstract The document a resource pool belongs to
 */
@property (nonatomic,strong,readonly) RKDocument *document;

/*!
 @abstract Returns the index of a font. 
 @discussion If the font is not indexed, it will be registered. The font name is stored with all non-standard traits (e.g. Roman, Condensed). Standard traits (Bold, Italic) are removed.
 */
- (NSUInteger)indexOfFont:(CTFontRef)font;

/*!
 @abstract Returns the index of a color. 
 @discussion If the color is not indexed, it will be registered. Colors will be registered without the alpha channel. The color must be in the kCGColorSpaceGenericRGB color space, otherwise an exception will be thrown.
 */
- (NSUInteger)indexOfColor:(CGColorRef)color;

/*!
 @abstract Registers a referenced file and returns a referencable filename
 */
- (NSString *)registerFileWrapper:(NSFileWrapper *)file;


/*!
 @abstract Returns the index of a paragraph style
 @discussion The paragraph style must be registered to the document in advance
 */
- (NSUInteger)indexOfParagraphStyle:(NSString *)paragraphStyleName;

/*!
 @abstract Returns the index of a character style
 @discussion The paragraph style must be registered to the document in advance
 */
- (NSUInteger)indexOfCharacterStyle:(NSString *)characterStyleName;


/*!
 @abstract Returns the collected font families sorted by their indices
 @discussion Elements are NSString
 */
- (NSArray *)fontFamilyNames;

/*!
 @abstract Returns the collected colors sorted by their indices
 @discussion The elements are NSString containing an RTF color definition
 */
- (NSArray *)colors;

/*!
 @abstract A dictionary mapping from filenames to the file wrappers of all attached files
 */
@property (nonatomic, strong, readonly) NSDictionary *attachmentFileWrappers;

/*!
 @abstract Keeps track of all lists and their enumeration counts during the processing of an attributed string
 */
@property (nonatomic, strong, readonly) RKListCounter *listCounter;

@end
