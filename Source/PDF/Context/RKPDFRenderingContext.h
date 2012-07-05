//
//  RKPDFRenderingContext.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument, RKPDFTextObject;

/*!
 @abstract Specifies enumeration options for text objects during PDF rendering
 @const
    RKPDFRenderingEnumerateForPage          The enumeration index is relative to the number of text objects of the same class used in the currently rendered page. This index is newly calculated for each page. 
                                            Requesting the index for the same text object on different pages might lead to different results.
 
    RKPDFRenderingEnumerateForSection       The enumeration index is relative to the number of text objects of the same class inside the section of the text object
    RKPDFRenderingEnumerateForDocument      The enumeration index is relative to the number of text objects of the same class inside the current document
 */
typedef enum : NSUInteger {
    RKPDFRenderingEnumerateForPage          = 0,
    RKPDFRenderingEnumerateForSection       = 1,
    RKPDFRenderingEnumerateForDocument      = 2
}RKPDFRenderingEnumerationPolicy;

/*!
 @abstract A context storing all information required during the PDF rendering
 */
@interface RKPDFRenderingContext : NSObject

/*!
 @abstract Initializes a new PDF context using a RTF document
 @discussion Creates a PDF context for the given document using the document meta data.
 */
- (id)initWithDocument:(RKDocument *)document;

/*!
 @abstract Closes the context and provides the PDF data object
 @discussion Do not use a context after closing it.
 */
- (NSData *)close;

/*!
 @abstract The document that is associated with this context
 */
@property (nonatomic, strong, readonly) RKDocument *document;

/*!
 @abstract All sections that should be rendered (array of RKSection)
 @discussion The rendering might add additional sections for endnotes etc.
 */
@property (nonatomic, strong, readonly) NSArray *sections;

/*!
 @abstract The currently rendered section
 */
@property (nonatomic, strong, readonly) RKSection *currentSection;

/*!
 @abstract The number of the currently rendered page
 */
@property (nonatomic, readonly) NSUInteger currentPageNumber;

/*!
 @abstract The number of the currently rendered page (using the requested string format of the current section)
 */
@property (nonatomic, strong, readonly) NSString* stringForCurrentPageNumber;

/*!
 @abstract The number of the currently rendered section
 */
@property (nonatomic, strong, readonly) NSString* stringForCurrentSectionNumber;

/*!
 @abstract The graphics context of the current rendering
 */
@property (nonatomic, retain, readonly) __attribute__((NSObject)) CGContextRef pdfContext;

/*!
 @abstract The footnote string that has not been rendered so far
 */
@property (nonatomic, strong) NSAttributedString *remainingFootnotes;



#pragma mark - Section managment

/*!
 @abstract Adds an additional section to the rendering
 */
- (void)insertSection:(RKSection *)section atIndex:(NSUInteger)index;



#pragma mark - Text object managment

/*!
 @abstract Registers a text object to the document for a certain section
 */
- (void)registerTextObject:(RKPDFTextObject *)textObject forSection:(RKSection *)section withEnumerationPolicy:(RKPDFRenderingEnumerationPolicy)enumerationPolicy;

/*!
 @abstract Provides the index of a text object
 @discussion Returns NSNotFound if the object is not registered.
 */
- (NSUInteger)indexOfTextObject:(RKPDFTextObject *)textObject;

/*!
 @abstract Returns a dictionary mapping from the indices of all text objects to such text object instance that have been registered for a certain section and page
 */
- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName section:(RKSection *)section page:(NSUInteger)page;

/*!
 @abstract Returns a dictionary mapping from the indices of all text objects to such text object instance that have been registered for a certain section
 */
- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName section:(RKSection *)section;

/*!
 @abstract Returns a dictionary mapping from the indices of all text objects to such text object instance that have been registered globally
 */
- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName;



#pragma mark - Page context

/*!
 @abstract Switches to the next section of the document
 */
- (void)nextSection;

/*!
 @abstract Starts a new page in the rendering context
 */
- (void)startNewPage;

/*!
 @abstract Starts a new column in the rendering context
 @discussion Returns NO, if all columns of the page are used.
 */
- (BOOL)startNewColumn;


@end
