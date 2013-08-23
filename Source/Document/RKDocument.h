//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTypes.h"

@class RKSection;

/*
 @abstract Representation of an RTF document
 @discussion An RTF document is composed of multiple sections and provides settings for document formatting and meta data.
 */
@interface RKDocument : NSObject <NSCopying>

/*!
 @abstract Creates a document based on an array of sections
 */
+ (RKDocument *)documentWithSections:(NSArray *)sections;

/*!
 @abstract Creates a document based on an attributed string. 
 @discussion The section containing the string will be automatically created.
 */
+ (RKDocument *)documentWithAttributedString:(NSAttributedString *)string;

/*!
 @abstract Initializes a document with a single attributed string representing its content
 */
- (id)initWithAttributedString:(NSAttributedString *)string;

/*!
 @abstract Initializes a document with an array of sections
 */
- (id)initWithSections:(NSArray *)array;

/*!
 @abstract The sections a document consists of.
 */
@property(nonatomic, strong) NSArray *sections;

/*!
 @abstract Document meta data
 @discussion A dictionary of document meta data. It is allowed to place arbitrary meta properties here. The RTF definition provides the following meta data:

    NSTitleDocumentAttribute
    NSCompanyDocumentAttribute
    NSCopyrightDocumentAttribute
    NSSubjectDocumentAttribute
    NSAuthorDocumentAttribute
    NSKeywordsDocumentAttribute
    NSCommentDocumentAttribute
    NSEditorDocumentAttribute
    NSCreationTimeDocumentAttribute
    NSModificationTimeDocumentAttribute
    NSManagerDocumentAttribute
    NSCategoryDocumentAttribute
*/
@property(nonatomic, strong) NSDictionary *metadata;


#pragma mark - Formatting

/*!
 @abstract Specifies whether hyphenation is enabled in this document.
 */
@property(nonatomic) BOOL hyphenationEnabled;

/*!
 @abstract Specifies a locale for the document (set to the default locale)
 */
@property(nonatomic) NSLocale *locale;

/*!
 @abstract Page size in points
 */
@property(nonatomic) CGSize pageSize;

/*!
 @abstract The distance from the top page border to the header in points
 */
@property(nonatomic) CGFloat headerSpacingBefore;

/*!
 @abstract The minimum distance from the the header to the content area.
 @discussion PDF-only.
 */
@property(nonatomic) CGFloat headerSpacingAfter;

/*!
 @abstract The minimum distance from the the footer to the content area.
 @discussion PDF-only.
 */
@property(nonatomic) CGFloat footerSpacingBefore;

/*!
 @abstract The distance from the bottom page border to the footer in points
 */
@property(nonatomic) CGFloat footerSpacingAfter;

/*!
 @abstract The distance from the content text to the footnotes
 @discussion PDF-only.
 */
@property(nonatomic) CGFloat footnoteSpacingBefore;

/*!
 @abstract Page insets in points
 */
@property(nonatomic) RKPageInsets pageInsets;

/*!
 @abstract The width of the page gutter
 */
@property(nonatomic) CGFloat pageGutterWidth;

/*!
 @abstract Page orientation
 */
@property(nonatomic) RKPageOrientation pageOrientation;

/*!
 @abstract Specifies the placement of footnotes within the document
 */
@property(nonatomic) RKFootnotePlacement footnotePlacement;

/*!
 @abstract Specifies the placement of endnotes within the document
 */
@property(nonatomic) RKEndnotePlacement endnotePlacement;

/*!
 @abstract Specifies the footnote enumeration style
 */
@property(nonatomic) RKFootnoteEnumerationStyle footnoteEnumerationStyle;

/*!
 @abstract Specifies the endnote enumeration style
 */
@property(nonatomic) RKFootnoteEnumerationStyle endnoteEnumerationStyle;

/*!
 @abstract Specifies a policy for enumeration of footnotes
 */
@property(nonatomic) RKFootnoteEnumerationPolicy footnoteEnumerationPolicy;

/*!
 @abstract Specifies a policy for enumeration of endnotes
 @discussion Valid values are RKFootnoteEnumerationPerSection and RKFootnoteContinuousEnumeration
 */
@property(nonatomic) RKFootnoteEnumerationPolicy endnoteEnumerationPolicy;

/*!
 @abstract Specifies document-wide paragraph styles
 @discussion A mapping from style names to a NSDictionary containing style information of an attributed string. In order to use a paragraph style in any document section it must be registered here.
 */
@property(nonatomic,strong,readwrite) NSDictionary *paragraphStyles;

/*!
 @abstract Specifies document-wide character styles
 @discussion A mapping from style names to a NSDictionary containing style information of an attributed string. In order to use a character style in any document section it must be registered here.
 */
@property(nonatomic,strong,readwrite) NSDictionary *characterStyles;

/*!
 @abstract Section numbering style
 */
@property(nonatomic) RKPageNumberingStyle sectionNumberingStyle;

/*!
 @abstract Page binding
 */
@property(nonatomic) RKPageBindingPosition pageBinding;



#pragma mark - Convenience methods

/*!
 @abstract Generates a footnote marker for the given index according to the style setting.
 @discussion Convenience method that may be used to guarantee compatibility with formats not supporting footnotes.
 */
+ (NSString *)footnoteMarkerForIndex:(NSUInteger)index usingEnumerationStyle:(RKFootnoteEnumerationStyle)enumerationStyle;

@end

/*!
 @abstract Methods for exporting RTFs
 */
@interface RKDocument (Exporting)

/*!
 @abstract Exports the document as RTF with embedded pictures, optimized for Microsoft Word.
 */
- (NSData *)wordRTF;

/*!
 @abstract Exports the document as RTF without pictures, optimized for the Cocoa text system.
 */
- (NSData *)systemRTF;

/*!
 @abstract Exports the document as RTFD 
 @discussion Creates a file wrapper containing the RTF and all referenced pictures
 This method will modify the preferredFilename of any NSFileWrapper used as text attachment.
 */
- (NSFileWrapper *)RTFD;

/*!
 @abstract Exports the document as PDF
 */
- (NSData *)PDF;

@end


/*!
 @abstract Methods required to test RTF generation
 */
@interface RKDocument (TestingSupport)

/*!
 @abstract Changes the usage of random list identifiers in RKDocument exports
 @discussion Normally, RTFKit has to create random list identifiers for compatibility with Microsoft Word. To improve testing, this can be switched off here.
 */
+ (void)useRandomListIdentifiers:(BOOL)useRandomListIdentifier;

/*!
 @abstract Specifies whether RTFKit is using random list identifier or not
 @discussion This is usually set to YES (it might be only switched off for testing)
 */
+ (BOOL)isUsingRandomListIdentifier;

@end
