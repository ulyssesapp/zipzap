//
//  RKDOCXConversionContext.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
	#define	ULFont				UIFont
#else
	#define ULFont				NSFont
#endif

/*!
 @abstract The filename of the relationship target relative to the location of the relationships source.
 @discussion See ISO 29500-2:2012: §9.3.2.2.
 */
extern NSString *RKDOCXConversionContextRelationshipTarget;

/*!
 @abstract The relationship type URI for the relationship target.
 @discussion See ISO 29500-2:2012: §9.3.2.2.
 */
extern NSString *RKDOCXConversionContextRelationshipTypeName;

/*!
 @abstract The relationship identifier as a string containing a bare number.
 @discussion Other parts of the identifier are not included (e.g. "rId"). See ISO 29500-2:2012: §9.3.2.2.
 */
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
@property(nonatomic, readonly) RKDocument *document;

/*!
 @abstract Mixes the given paragraph and character style attributes and caches and returns the resulting style attributes.
 @discussion When processing the default style, this method returns always nil to ensure that the default style will not be based on any reference values.
 */
- (NSDictionary *)cachedStyleFromParagraphStyle:(NSString *)paragraphStyle characterStyle:(NSString *)characterStyle processingDefaultStyle:(BOOL)processingDefaultStyle;

/*!
 @abstract Checks the given font family for competing font styles.
 */
- (BOOL)isFullNameRequieredForFont:(ULFont *)font;


#pragma mark - Output context

/*!
 @abstract The data representation of the generated DOCX file as far as collected.
 @discussion Should be used only after performing all required conversion steps.
 */
@property(nonatomic, readonly) NSData *docxRepresentation;

/*!
 @abstract Contains all content types collected from the XML files of the document.
 @discussion Maps from filename to content type.
 */
@property(nonatomic, readonly) NSDictionary *usedXMLTypes;

/*!
 @abstract Contains all content types collected from additional asset files used inside the document.
 @discussion Maps from path extensions to MIME types.
 */
@property(nonatomic, readonly) NSDictionary *usedMIMETypes;

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
 @discussion The ID has no special use, it just needs to be unique.
 */
- (NSString *)newImageId;

/*!
 @abstract Returns the next unique ID for deleted, inserted and annotated run elements.
 @discussion The ID has no special use, it just needs to be unique.
 */
- (NSString *)newReviewId;

#pragma mark - Footnotes and Endnotes

/*!
 @abstract Mapping from footnote identifiers (NSNumber) to footnote content (NSXMLElement).
 */
@property(nonatomic, readonly) NSDictionary *footnotes;

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

/*!
 @abstract Returns YES is the passed list item has been used already. Returns NO if not and remembers the visit.
 */
- (BOOL)consumeListItem:(RKListItem *)listItem;


#pragma mark - Document relationships

/*!
 @abstract Specifies which relationship source the attributed string belongs to.
 @discussion E.g. "document.xml" or "header2.xml".
 */
@property (nonatomic, readwrite) NSString *currentRelationshipSource;

/*!
 @abstract Maps from filenames of relationship sources to relationship descriptors.
 @discussion Used to build relationship files (See ISO 29500-2:2012: §9.3.1). See RKDOCXConversionContextRelationshipTarget, … for keys used inside relationship descriptors.
 */
@property (nonatomic, readonly) NSDictionary *documentRelationships;

/*!
 @abstract Returns the relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

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
