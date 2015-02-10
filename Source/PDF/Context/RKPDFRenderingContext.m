//
//  RKPDFRenderingContext.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFRenderingContext.h"
#import "RKDocument+PDFUtilities.h"
#import "RKSection+PDFUtilities.h"
#import "RKPDFTextObject.h"
#import "RKPDFFootnote.h"
#import "RKListCounter.h"

#import "NSAttributedString+PDFUtilities.h"


@interface RKPDFRenderingContext ()
{
	// An array of dictionaries containing saved states
	NSMutableArray *_savedStates;
	
    // The data of the generated PDF document
    NSMutableData *_pdfData;
    
    // The rendered sections
    NSMutableArray *_sections;

    // Section number
    NSUInteger _currentSectionNumber;
    
    // Note indexes
    NSMutableArray *_documentNotes;
    NSMutableArray *_sectionNotes;
    NSMutableArray *_pageNotes;
    
    // Note counters
    NSUInteger _footnoteCounter;
    NSUInteger _endnoteCounter;
    NSUInteger _footnoteAnchorCounter;
    
    // The graphics context
    CGContextRef _pdfContext;
	
    #if !TARGET_OS_IPHONE
        NSGraphicsContext *nsPdfContext;
    #endif
	
	// The operation handle used for cancellation
	RKOperationHandle *_operationHandle;
}

@end


@implementation RKPDFRenderingContext

@synthesize sections=_sections, documentNotes=_documentNotes, sectionNotes=_sectionNotes, pageNotes=_pageNotes, pdfContext=_pdfContext;

#if !TARGET_OS_IPHONE
@synthesize nsPdfContext=_nsPdfContext;
#endif

- (id)initWithDocument:(RKDocument *)document operationHandle:(RKOperationHandle *)operationHandle
{
    self = [self init];
    if (!self)
        return nil;
    
    // Initialize PDF context
    _pdfData = [NSMutableData new];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)_pdfData);
    CGRect mediaBox = document.pdfMediaBox;
    
    _pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, (__bridge CFDictionaryRef)document.pdfMetadata);
    
    #if !TARGET_OS_IPHONE
    _nsPdfContext = [NSGraphicsContext graphicsContextWithGraphicsPort:_pdfContext flipped:NO];
    #endif
    
    // Initialize other references
    _document = document;
    _sections = [NSMutableArray new];

    _currentSectionNumber = NSUIntegerMax;
    _currentPageNumber = NSUIntegerMax;
    _currentColumnNumber = NSUIntegerMax;
    _pageNumberOfCurrentSection = NSUIntegerMax;
    
    _footnoteAnchorCounter = 0;
    
    _documentNotes = [NSMutableArray new];
    _sectionNotes = [NSMutableArray new];
    _pageNotes = [NSMutableArray new];
    
    _listCounter = [RKListCounter new];

	_savedStates = [NSMutableArray new];
	_operationHandle = operationHandle;
	
    CFRelease(dataConsumer);
    
    return self;
}

- (NSData *)close
{
    if (_pageNumberOfCurrentSection != NSUIntegerMax)
        CGPDFContextEndPage(_pdfContext);
    
    CGPDFContextClose(_pdfContext);
    CFRelease(_pdfContext);

	if (self.operationHandle.isCancelled)
		return nil;
	
    return _pdfData;
}



#pragma mark - Section managment

- (void)insertSection:(RKSection *)section atIndex:(NSUInteger)index
{
    [_sections insertObject:section atIndex:index];
}

- (void)appendSection:(RKSection *)section
{
    [self insertSection:section atIndex:_sections.count];
}

- (void)flushSectionNotes
{
	_sectionNotes = [NSMutableArray new];
}



#pragma mark - Sections and Pages

- (RKSection *)currentSection
{
    NSAssert(_currentSectionNumber < _sections.count, @"Invalid section");
    
    return _sections[_currentSectionNumber];
}

- (NSString *)stringForCurrentPageNumber
{
    if (self.currentSection.indexOfFirstPage == NSNotFound)
        return [self.currentSection stringForPageNumber: (self.currentPageNumber)];
    else
        return [self.currentSection stringForPageNumber: (self.pageNumberOfCurrentSection + self.currentSection.indexOfFirstPage - 1)];
}

- (NSString *)stringForCurrentSectionNumber
{
        return [self.document stringForSectionNumber: self.currentSectionNumber + 1];
}

- (void)nextSection
{
    // Update page and section counter
    [self resetSectionPageCount];
    _currentSectionNumber ++;
    
    // Reset footnote counter, if required
    if (self.document.footnoteEnumerationPolicy == RKFootnoteEnumerationPerSection)
        _footnoteCounter = 0;

    // Reset endnote counter, if required
    if (self.document.endnoteEnumerationPolicy == RKFootnoteEnumerationPerSection)
        _endnoteCounter = 0;
}

- (void)startNewPage
{
    NSAssert(self.currentSectionNumber != NSUIntegerMax, @"No section entered");

    // End current page
    if (_currentPageNumber != NSUIntegerMax)
        CGPDFContextEndPage(_pdfContext);
    // Reset page counter if no page was ended
    else
        _currentPageNumber = 0;
    
    if (_pageNumberOfCurrentSection == NSUIntegerMax)
        _pageNumberOfCurrentSection = 0;
    
    // Start new page
    CGRect mediaBox = _document.pdfMediaBox;
	NSParameterAssert(mediaBox.size.height > 1);
	NSParameterAssert(mediaBox.size.width > 1);
	
    NSDictionary *pageDictionary = @{(__bridge id)kCGPDFContextMediaBox: [NSData dataWithBytes:(uint8_t *)&mediaBox length:sizeof(CGRect)]};
    
    CGPDFContextBeginPage(_pdfContext, (__bridge CFDictionaryRef)pageDictionary);
    
    // Update page counter
    _currentPageNumber ++;
    _pageNumberOfCurrentSection ++;
    _currentColumnNumber = NSUIntegerMax;
    
    // Reset footnote counter, if required
    if (self.document.footnoteEnumerationPolicy == RKFootnoteEnumerationPerPage)
        _footnoteCounter = 0;
    
    // Reset endnote counter, if required
    if (self.document.endnoteEnumerationPolicy == RKFootnoteEnumerationPerPage)
        _endnoteCounter = 0;
    
    // Reset page notes
    _pageNotes = [NSMutableArray new];
}

- (void)resetSectionPageCount
{
	_pageNumberOfCurrentSection = NSUIntegerMax;
}

- (BOOL)startNewColumn
{
    NSAssert(self.currentSectionNumber != NSUIntegerMax, @"No section entered");
    
    if (_currentColumnNumber == NSUIntegerMax) {
        _currentColumnNumber = 0;
        return YES;
    }
    
    if (_currentColumnNumber >= self.currentSection.numberOfColumns)
        return NO;
    
    _currentColumnNumber ++;
    return YES;

}



#pragma mark - Footnote managment

- (NSString *)enumeratorForNote:(RKPDFFootnote *)note
{
    RKNoteIndexType noteIndexType = (note.isEndnote) ? [self indexTypeForEndnotes] : [self indexTypeForFootnotes];
    NSMutableArray *noteIndex = [self noteIndexForType: noteIndexType];
    
    // Test, whether there is already a key
    for (NSDictionary *noteDescriptor in noteIndex) {
        if ([noteDescriptor objectForKey: RKFootnoteObjectKey] == note)
            return noteDescriptor[RKFootnoteEnumerationStringKey];
    }

    NSString *enumerationString;
    
    // Otherwise create an enumeration string
    if (note.isEndnote) {
        _endnoteCounter ++;
        enumerationString = [RKDocument footnoteMarkerForIndex:_endnoteCounter usingEnumerationStyle:self.document.endnoteEnumerationStyle];
    }
    else {
        _footnoteCounter ++;
        enumerationString = [RKDocument footnoteMarkerForIndex:_footnoteCounter usingEnumerationStyle:self.document.footnoteEnumerationStyle];
    }

    // Register note to index
    NSDictionary *noteDescriptor = @{
        RKFootnoteObjectKey:                note,
        RKFootnoteEnumerationStringKey:     enumerationString
    };

    [noteIndex addObject: noteDescriptor];

    return enumerationString;
}

- (void)unregisterNote:(RKPDFFootnote *)note
{
	// Restore counters
	if (note.isEndnote)
		_endnoteCounter --;
	else
		_footnoteCounter --;
	
	// Update footnote index
    RKNoteIndexType noteIndexType = (note.isEndnote) ? [self indexTypeForEndnotes] : [self indexTypeForFootnotes];
    NSMutableArray *noteIndex = [self noteIndexForType: noteIndexType];
	__block NSInteger itemIndex = NSNotFound;
	
	[noteIndex enumerateObjectsUsingBlock:^(NSDictionary *descriptor, NSUInteger idx, BOOL *stop) {
		if (descriptor[RKFootnoteObjectKey] == note) {
			itemIndex = idx;
			*stop = YES;
		}
	}];
	
	if (itemIndex != NSNotFound) {
		[noteIndex removeObjectAtIndex: itemIndex];
	}
}

- (void)unregisterNotesInAttributedString:(NSAttributedString *)stringWithNotes range:(NSRange)range
{
	[stringWithNotes enumerateAttribute:RKTextObjectAttributeName inRange:range options:0 usingBlock:^(RKPDFFootnote *note, NSRange range, BOOL *stop) {
		if ([note isKindOfClass: RKPDFFootnote.class])
			[self unregisterNote: note];
	}];
}

- (NSMutableArray *)noteIndexForType:(RKNoteIndexType)noteIndexType
{
    switch (noteIndexType) {
        case RKNoteIndexForDocument:
            return _documentNotes;
        
        case RKNoteIndexForSection:
            return _sectionNotes;
            
        case RKNoteIndexForPage:
            return _pageNotes;
    }
    
    NSParameterAssert(false);
    return nil;
}

- (RKNoteIndexType)indexTypeForFootnotes
{
    switch (self.document.footnotePlacement) {
        case RKFootnotePlacementDocumentEnd:
            return RKNoteIndexForDocument;
        
        case RKFootnotePlacementSectionEnd:
            return RKNoteIndexForSection;
            
        case RKFootnotePlacementSamePage:
            return RKNoteIndexForPage;
    }

    NSParameterAssert(false);
    return 0;
}

- (RKNoteIndexType)indexTypeForEndnotes
{
    switch (self.document.endnotePlacement) {
        case RKEndnotePlacementDocumentEnd:
            return RKNoteIndexForDocument;
            
        case RKEndnotePlacementSectionEnd:
            return RKNoteIndexForSection;
    }

    NSParameterAssert(false);
    return 0;
}

- (NSArray *)registeredPageNotesInAttributedString:(NSAttributedString *)string range:(NSRange)range
{
    NSMutableArray *extractedPageNotes = [NSMutableArray new];
    
    // This document has no page notes
    if (self.document.footnotePlacement != RKFootnotePlacementSamePage)
        return extractedPageNotes;
    
    // Extract notes
    [string enumerateAttribute:RKTextObjectAttributeName inRange:range options:0 usingBlock:^(RKPDFFootnote *currentFootnote, NSRange range, BOOL *stop) {
        // We are only interested in footnotes - ignore other text objects
        if (![currentFootnote isKindOfClass: RKPDFFootnote.class] || currentFootnote.isEndnote)
            return;
        
        for (NSDictionary *pageNote in self.pageNotes) {
            // Add descriptor, if it has been registered to this page
            if ([pageNote objectForKey: RKFootnoteObjectKey] == currentFootnote)
                [extractedPageNotes addObject: pageNote];
        }
    }];
    
    return extractedPageNotes;
}

- (NSString *)newFootnoteAnchor
{
    _footnoteAnchorCounter ++;
    
    return [NSString stringWithFormat: @"note-%lu", _footnoteAnchorCounter];
}

@end
