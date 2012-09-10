//
//  NSAttributedString+PDFUtilities.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFTextObject, RKPDFRenderingContext, RKPDFFootnote;

/*!
 @abstract An attribute denoting the hyphenation character that should be used a soft hyphenation
 */
extern NSString *RKHyphenationCharacterAttributeName;

/*!
 @abstract The key mapping to the RKPDFFootnote object inside a footnote descriptor
 */
extern NSString *RKFootnoteObjectKey;

/*!
 @abstract The key mapping to the enumeration string inside a footnote descriptor
 */
extern NSString *RKFootnoteEnumerationStringKey;

/*!
 @abstract A special attribute that indicates a text object
 @discussion Reference to a RKPDFTextObject
 */
extern NSString *RKTextObjectAttributeName;

/*!
 @abstract A special attribute that indicates the reqirement of a custom text renderer
 @discussion Reference to an Array of RKPDFTextRenderer classes
 */
extern NSString *RKTextRendererAttributeName;

/*!
 @abstract An attribute that contains the name of an anchor
 @discussion NSString
 */
extern NSString *RKPDFAnchorAttributeName;

/*!
 @abstract An attribute that contains a link to an anchor
 @discussion NSString with the anchor name
 */
extern NSString *RKPDFAnchorLinkAttributeName;

/*!
 @abstract Utility methods for PDF generation
 */
@interface NSAttributedString (PDFUtilities)

/*!
 @abstract Creates a new attributed string from the current string by applying the footnote style using a footnote index.
 @discussion  The generated attributed string is in core text representation.
 */
+ (NSAttributedString *)attributedStringWithNote:(RKPDFFootnote *)note enumerationString:(NSString *)enumerationString;

/*!
 @abstract Creates an attributed string containing the given footnotes or endnotes. The generated attributed string is in core text representation.
 @discussion The notes are stored as an array of footnote descriptors (NSDictionary) containing the footnote content (RKFootnoteContentKey) as NSAttributedString in core text representation and the enumeration string of the footnote (RKFootenoteEnumerationStringKey).
 */
+ (NSAttributedString *)noteListFromNotes:(NSArray *)notes;

/*!
 @abstract Creates a styled footnote enumerator using a string. The generated attributed string is in core text representation.
 @discussion The styling of the enumerator is based on the given font.
 */
+ (NSAttributedString *)footnoteEnumeratorFromString:(NSString *)enumeratorString usingFont:(CTFontRef)font;

/*!
 @abstract Provides an attributed string with a fixed-width and fixed-height spacing
 @discussion  The generated attributed string is in core text representation.
 */
+ (NSAttributedString *)spacingWithHeight:(CGFloat)height width:(CGFloat)width;

@end

@interface NSMutableAttributedString (PDFCoreTextConversion)

/*!
 @abstract Sets the given character as text object using custom rendering
 @discussion Only one text object can be placed on the same index at once. It depends on the type of the text object whether additional text renderers are effective or not.
 */
- (void)addTextObjectAttribute:(RKPDFTextObject *)textObject atIndex:(NSUInteger)index;

/*!
 @abstract Adds a custom text render to an attributed string range respecting the priority of the renderer class
 @discussion The renderer must be a class derived from RKPDFTextRenderer.
 */
- (void)addTextRenderer:(Class)textRender forRange:(NSRange)range;

/*!
 @abstract Adds a local destination attribute to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationAnchor:(NSString *)anchorName forRange:(NSRange)range;

/*!
 @abstract Adds a local destination link to an attributed string and setups the required text renderer
 */
- (void)addLocalDestinationLinkForAnchor:(NSString *)anchorName forRange:(NSRange)range;

@end
