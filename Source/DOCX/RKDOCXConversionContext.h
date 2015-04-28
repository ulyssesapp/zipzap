//
//  RKDOCXConversionContext.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

extern NSString *RKDOCXConversionContextRelationshipTypeName;
extern NSString *RKDOCXConversionContextRelationshipIdentifierName;

/*!
 @abstract Collects state generated during the conversion process that is shared between conversion steps.
 @discussion This includes the final DOCX output, as well as any intermediate state shared between different conversion passes.
 */
@interface RKDOCXConversionContext : NSObject

/*!
 @abstract Initializes the conversion context with a document the conversion process is operating on.
 */
- (instancetype)initWithDocument:(RKDocument *)document;

/*!
 @abstract The document a conversion context belongs to.
 */
@property (nonatomic, readonly) RKDocument *document;


#pragma mark - Output context

/*!
 @abstract The data representation of the generated DOCX file as far as collected.
 @discussion Should be used only after performing all required conversion steps.
 */
@property (nonatomic, readonly) NSData *docxRepresentation;

/*!
 @abstract Adds the given document part to the context object and registers the content type for the filename.
 @discussion Throws an exception when adding duplicate files.
 */
- (void)addXMLDocumentPart:(NSXMLDocument *)part withFilename:(NSString *)filename contentType:(NSString *)contentType;

/*!
 @abstract Adds the given document part to the context object and registers the content type for the path extension of the filename.
 @discussion Throws an exception when adding duplicate files.
 */
- (void)addBinaryDocumentPart:(NSData *)part withFileName:(NSString *)filename MIMEType:(NSString *)MIMEType;

/*!
 @abstract Contains all content types collected from the XML files of the document.
 @discussion Maps from filename to content type.
 */
@property (nonatomic, readonly) NSDictionary *usedXMLTypes;

/*!
 @abstract Contains all content types collected from additional asset files used inside the document.
 @discussion Maps from path extensions to MIME types.
 */
@property (nonatomic, readonly) NSDictionary *usedMIMETypes;


#pragma mark - Footnotes and Endnotes

/*!
 @abstract Mapping from footnote identifiers (NSNumber) to footnote content (NSXMLElement).
 */
@property (nonatomic, readonly) NSDictionary *footnotes;

/*!
 @abstract Creates and returns an identifier for the given footnote content.
 */
- (NSUInteger)indexForFootnoteContent:(NSArray *)content;

/*!
 @abstract Mapping from endnote identifiers (NSNumber) to endnote content (NSXMLElement).
 */
@property (nonatomic, readonly) NSDictionary *endnotes;

/*!
 @abstract Creates and returns an identifier for the given endnote content.
 */
- (NSUInteger)indexForEndnoteContent:(NSArray *)content;


#pragma mark - Headers and Footers

/*!
 @abstract The number of headers used in the document.
 */
@property (nonatomic) NSUInteger headerCount;

/*!
 @abstract The number of headers used in the document.
 */
@property (nonatomic) NSUInteger footerCount;

/*!
 @abstract Whether the document contains any section requiring different header or footer for even/odd pages.
 @discussion Defaults to NO, set to YES by the section writer.
 */
@property (nonatomic) BOOL evenAndOddHeaders;


#pragma mark - Lists

/*!
 @abstract Mapping from list style identifiers (NSNumber) to list styles (RKListStyle).
 */
@property (nonatomic, readonly) NSDictionary *listStyles;

/*!
 @abstract Creates and returns an identifier for the given list style.
 */
- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle;


#pragma mark - Document relationships

/*!
 @abstract Mapping from relationship targets (NSString) to relationship identifiers (NSNumber).
 */
@property (nonatomic, readonly) NSDictionary *documentRelationships;

/*!
 @abstract Returns the relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

@end
