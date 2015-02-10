//
//  RKPDFRenderingContext.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument, RKOperationHandle, RKPDFTextObject, RKPDFFootnote, RKSection, RKListCounter;

typedef enum : NSUInteger {
    RKNoteIndexForDocument          = 0,
    RKNoteIndexForSection           = 1,
    RKNoteIndexForPage              = 2    
}RKNoteIndexType;


/*!
 @abstract A context storing all information required during the PDF rendering
 */
@interface RKPDFRenderingContext : NSObject

/*!
 @abstract Initializes a new PDF context using a RTF document
 @discussion Creates a PDF context for the given document using the document meta data. The sections of the document are initially not added to the context.
 */
- (id)initWithDocument:(RKDocument *)document operationHandle:(RKOperationHandle *)operationHandle;

/*!
 @abstract Closes the context and provides the PDF data object
 @discussion Do not use a context after closing it.
 */
- (NSData *)close;


#pragma mark - Context properties

/*!
 @abstract The operation handle of the running rendering operation.
 */
@property (nonatomic, strong, readonly) RKOperationHandle *operationHandle;

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
@property (nonatomic, readonly) NSUInteger currentSectionNumber;

/*!
 @abstract The number of the currently rendered page (document wide)
 */
@property (nonatomic, readonly) NSUInteger currentPageNumber;

/*!
 @abstract The number of the currently rendered page (for current section)
 */
@property (nonatomic, readonly) NSUInteger pageNumberOfCurrentSection;

/*!
 @abstract The number of the currently rendered column
 */
@property (nonatomic, readonly) NSUInteger currentColumnNumber;

/*!
 @abstract The number of the currently rendered page (using the requested string format of the current section)
 */
@property (nonatomic, strong, readonly) NSString* stringForCurrentPageNumber;

/*!
 @abstract The number of the currently rendered page (using the requested string format of the current section)
 */
@property (nonatomic, strong, readonly) NSString* stringForCurrentSectionNumber;

/*!
 @abstract The graphics context of the current rendering
 */
@property (nonatomic, retain, readonly) __attribute__((NSObject)) CGContextRef pdfContext;

#if !TARGET_OS_IPHONE

/*!
 @abstract The graphics context of the current rendering as NSGraphicsContext
 */
@property (nonatomic, retain, readonly) NSGraphicsContext *nsPdfContext;


#endif


#pragma mark - Section managment

/*!
 @abstract Adds a section to the rendering
 */
- (void)insertSection:(RKSection *)section atIndex:(NSUInteger)index;

/*!
 @abstract Adds a section to the rendering
 */
- (void)appendSection:(RKSection *)section;

/*!
 @abstract Flushes all section notes
 */
- (void)flushSectionNotes;



#pragma mark - Footnote managment

/*!
 @abstract All footnotes and endnotes that have been collected so far that should be shown on the end of the document
 @discussion An array of dictionaries containing the attributed string of the footnote RKPDFFootnote object (RKFootnoteObjectKey) and the enumeration string of the note (RKFootnoteEnumerationStringKey). The array is ordered by the expected output ordering for the notes.
 */
@property (nonatomic, strong, readonly) NSArray *documentNotes;

/*!
 @abstract All footnotes and endnotes that have been collected so far that should be shown on the end of the current section
 @discussion An array of dictionaries containing the attributed string of the RKPDFFootnote object (RKFootnoteObjectKey) and the enumeration string of the note (RKFootnoteEnumerationStringKey). The array is ordered by the expected output ordering for the notes.
 */
@property (nonatomic, strong, readonly) NSArray *sectionNotes;

/*!
 @abstract All footnotes and endnotes that have been collected so far that should be shown on the end of the current page
 @discussion An array of dictionaries containing the attributed string of the RKPDFFootnote object (RKFootnoteObjectKey) and the enumeration string of the note (RKFootnoteEnumerationStringKey). The array is ordered by the expected output ordering for the notes.
 */
@property (nonatomic, strong, readonly) NSArray *pageNotes;

/*!
 @abstract Requests an enumeration string for the given note with respect to the enumeration policy of the document, the current section and page
 @discussion The note is registered either to the documentNotes, sectionNotes or pageNotes.
 */
- (NSString *)enumeratorForNote:(RKPDFFootnote *)note;

/*!
 @abstract Provides the index type for footnotes according to the document settings
 */
@property (nonatomic, readonly) RKNoteIndexType indexTypeForFootnotes;

/*!
 @abstract Provides the index type for endnotes according to the document settings
 */
@property (nonatomic, readonly) RKNoteIndexType indexTypeForEndnotes;

/*!
 @abstract Provides all page notes that are visible in the 'pageNotes' array and in the given attributed string range
 @discussion Returns an array of dictionaries containing the attributed string of the footnote in core text representation (RKFootnoteContentKey) and the enumeration string of the note (RKFootnoteEnumerationStringKey). The array is ordered by the expected output ordering for the notes.
 */
- (NSArray *)registeredPageNotesInAttributedString:(NSAttributedString *)string range:(NSRange)range;

/*!
 @abstract Creates a new, unique footnote anchor
 */
- (NSString *)newFootnoteAnchor;

/*!
 @abstract Unregisters all footnote text objects (RKPDFFootnote) occuring in the given from the current index.
 @discussion Used for reverting all footnote counters generated for a certain line, if a line is discarded by the layout rules. This method expects that footnotes are only discarded immediately after adding them to the index. If further lines were generated in meanwhile, the index might get corrupted.
 */
- (void)unregisterNotesInAttributedString:(NSAttributedString *)stringWithNotes range:(NSRange)range;


#pragma mark - List rendering

/*!
 @abstract A list enumerator used to keep track over list styles and their enumeration states
 */
@property (nonatomic, strong, readonly) RKListCounter *listCounter;


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
 @abstract Resets the page count of the current section.
 @discussion Used for inserting blank pages to a section.
 */
- (void)resetSectionPageCount;

/*!
 @abstract Starts a new column in the rendering context
 @discussion Returns NO, if all columns of the page are used.
 */
- (BOOL)startNewColumn;


@end
