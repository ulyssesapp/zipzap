//
//  RKDocument.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTypes.h"

@class RKOperationHandle, RKSection;

/*
 @abstract Representation of an RTF document
 @discussion An RTF document is composed of multiple sections and provides settings for document formatting and meta data.
 */
@interface RKDocument : NSObject <NSCopying>

/*!
 @abstract Initializes a document without sections using default values for document format settings.
 @discussion Designated initializer.
 */
- (instancetype)init;

/*!
 @abstract Initializes a document based on the passed array of RKSections.
 */
- (instancetype)initWithSections:(NSArray *)sections;

/*!
 @abstract Initializes a document based on an attributed string. 
 @discussion The section containing the string will be automatically created.
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)string;

/*!
 @abstract The RKSections a document consists of.
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
 @discussion Defaults to A4.
 */
@property(nonatomic) CGSize pageSize;

/*!
 @abstract The distance from the top page border to the header in points
 @discussion Defaults to 36 pt.
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
 @discussion Defaults to 36 pt.
 */
@property(nonatomic) CGFloat footerSpacingAfter;

/*!
 @abstract The string attributes that should be used for styling the footnote anchor in the footnote area of a document
 @discussion Defaults to superscript. Paragraph style attributes are ignored.
 */
@property(nonatomic,strong,readwrite) NSDictionary *footnoteAreaAnchorAttributes;

/*!
 @abstract The horizontal position of the footnote divider
 @discussion Currently only NSLeftTextAlignment and NSRightTextAlignment are supported.
 */
@property(nonatomic) NSTextAlignment footnoteAreaDividerPosition;

/*!
 @abstract The distance from the content text to the divider of the footnotes area.
 @abstract The length of the footnote divider
 @discussion Only available in PDF export.
 */
@property(nonatomic) CGFloat footnoteAreaDividerLength;

/*!
 @abstract The width of the footnote divider
 @discussion Only available in PDF export.
 */
@property(nonatomic) CGFloat footnoteAreaDividerWidth;

/*!
 @discussion Defaults to 15pt.
 */
@property(nonatomic) CGFloat footnoteAreaDividerSpacingBefore;

/*!
 @abstract The distance from the divider of the footnote are to its content
 @discussion Defaults to 15pt. 
 */
@property(nonatomic) CGFloat footnoteAreaDividerSpacingAfter;

/*!
 @abstract The alignment of the footnote anchor.
 @discussion Defaults to left alignment.
 */
@property(nonatomic) NSTextAlignment footnoteAreaAnchorAlignment;

/*!
 @abstract The inset of the anchor in the footnote area.
 @discussion See -footnoteAreaAnchorAlignment to make the anchor left or right aligned. Defaults to 0. RTF: Anchor and content insets should not be overlapping, since they are implemented using tabulators.
 */
@property(nonatomic) CGFloat footnoteAreaAnchorInset;

/*!
 @abstract The inset of the content of the footnote area.
 @discussion Defaults to 20pt. RTF: Anchor and content insets should not be overlapping, since they are implemented using tabulators.
 */
@property(nonatomic) CGFloat footnoteAreaContentInset;

/*!
 @abstract Page insets in points
 @discussion Defaults to RKPageInsetsMake(90, 72, 72, 90)
 */
@property(nonatomic) RKPageInsets pageInsets;

/*!
 @abstract Page orientation
 @discussion Defaults to portrait.
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
 @abstract Specifies the document-wide default style.
 */
@property(nonatomic) NSDictionary *defaultStyle;

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
 @abstract Page binding option
 @discussion Will influence the placement of the inner and outer margin on single-sided printing. On double-sided printing, this option will determine the placement of the first page of the document and each section. Defaults to left-binding.
 */
@property(nonatomic) RKPageBindingPosition pageBinding;

/*!
 @abstract Specifies whether the document should is double sided.
 @discussion Will switch the placement of the inner and outer margin for left and right sides. Furthermore, new sections will be placed either only on right or left sides (depending on the page binding option). Thus empty pages may be generated on section breaks. Will be only used for PDF / Word export.
 */
@property(nonatomic) BOOL twoSided;


#pragma mark - Convenience methods

/*!
 @abstract Generates a footnote marker for the given index according to the style setting.
 @discussion Convenience method that may be used to guarantee compatibility with RTF formats not supporting footnotes.
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
 @discussion Several features are not available for System RTF (e.g. embedded images, footnotes, several page format settings).
 */
- (NSData *)systemRTF;

/*!
 @abstract Exports the document as RTFD 
 @discussion Creates a file wrapper containing the RTF and all referenced pictures. This method will modify the preferredFilename of any NSFileWrapper passed as text attachment. Several features are not available for System RTFD (e.g. footnotes, several page format settings).
 */
- (NSFileWrapper *)RTFD;

/*!
 @abstract Exports the document as DOCX
 @discussion Returns a data object representing a DOCX file.
 */
- (NSData *)DOCX;

/*!
 @abstract Exports the document as PDF
 @discussion The passed operation handle may be used to asynchronously abort a running PDF rendering.
 */
- (NSData *)PDFWithOperationHandle:(RKOperationHandle *)handle;

@end


/*!
 @abstract Methods required to test RTF generation
 */
@interface RKDocument (TestingSupport)

/*!
 @abstract Changes the usage of random list identifiers in RKDocument exports
 @discussion Normally, RTFKit needs to create random list identifiers for compatibility with Microsoft Word. To improve testing, this can be switched off here.
 */
+ (void)useRandomListIdentifiers:(BOOL)useRandomListIdentifier;

/*!
 @abstract Specifies whether RTFKit is using random list identifier or not
 @discussion This is usually set to YES (it might be only switched off for testing)
 */
+ (BOOL)isUsingRandomListIdentifier;

@end
