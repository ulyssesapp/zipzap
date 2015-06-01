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
 @abstract Specifies what document part the currently processed string belongs to.
 
 @const RKDOCXMainDocumentContext	String processing takes place in the context of the main document.
 @const RKDOCXEndnoteContext		String processing takes place in the context of a footnote.
 @const RKDOCXFootnoteContext		String processing takes place in the context of an endnote.
 */
typedef enum : NSUInteger {
	RKDOCXMainDocumentContext,
	RKDOCXEndnoteContext,
	RKDOCXFootnoteContext,
} RKDOCXProcessingContext;

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

/*!
 @abstract Mixes the given paragraph and character style attributes and caches and returns the resulting style attributes.
 */
- (NSDictionary *)cachedStyleFromParagraphStyle:(NSString *)paragraphStyle characterStyle:(NSString *)characterStyle;


#pragma mark - Output context

/*!
 @abstract The data representation of the generated DOCX file as far as collected.
 @discussion Should be used only after performing all required conversion steps.
 */
@property (nonatomic, readonly) NSData *docxRepresentation;

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

/*!
 @abstract Adds the given document part to the context object and registers the content type for the filename.
 @discussion Throws an exception when adding duplicate files.
 */
- (void)addDocumentPartWithXMLDocument:(NSXMLDocument *)part filename:(NSString *)filename contentType:(NSString *)contentType;

/*!
 @abstract Adds the given document part to the context object and registers the content type for the path extension of the filename.
 @discussion Throws an exception when adding duplicate files.
 */
- (void)addDocumentPartWithData:(NSData *)part filename:(NSString *)filename MIMEType:(NSString *)MIMEType;

/*!
 @abstract Returns the next unique ID for embedded images.
 @discussion The id has no special use, it just needs to be unique.
 */
- (NSString *)nextImageId;

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
 @abstract Specifies whether the current attributed string is part of the main document, an endnote or a footnote.
 */
@property (nonatomic) RKDOCXProcessingContext currentRelationshipContext;

/*!
 @abstract Mapping from document relationship targets (NSString) to document relationship identifiers (NSNumber) and document relationship types (NSString).
 */
@property (nonatomic, readonly) NSDictionary *documentRelationships;

/*!
 @abstract Returns the document relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForDocumentRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

/*!
 @abstract Mapping from endnote relationship targets (NSString) to endnote relationship identifiers (NSNumber) and endnote relationship types (NSString).
 */
@property (nonatomic, readonly) NSDictionary *endnoteRelationships;

/*!
 @abstract Returns the endnote relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForEndnoteRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

/*!
 @abstract Mapping from footnote relationship targets (NSString) to footnote relationship identifiers (NSNumber) and footnote relationship types (NSString).
 */
@property (nonatomic, readonly) NSDictionary *footnoteRelationships;

/*!
 @abstract Returns the footnote relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForFootnoteRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

/*!
 @abstract Mapping from relationship targets (NSString) to relationship types (NSString).
 */
@property (nonatomic, readonly) NSDictionary *packageRelationships;

/*!
 @abstract Adds a new package relationship to the packageRelationships dictionary of the context object.
 @discussion There is no relationship identifier needed.
 */
- (void)addPackageRelationshipWithTarget:(NSString *)target type:(NSString *)type;

@end
