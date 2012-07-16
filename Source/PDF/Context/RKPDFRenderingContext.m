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
#import "RKListEnumerator.h"

#import "NSAttributedString+PDFUtilities.h"


@interface RKPDFRenderingContext ()
{
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
    
    // The graphics context
    CGContextRef _pdfContext;
    NSGraphicsContext *nsPdfContext;
}

@end


@implementation RKPDFRenderingContext

@synthesize sections=_sections, documentNotes=_documentNotes, sectionNotes=_sectionNotes, pageNotes=_pageNotes, nsPdfContext=_nsPdfContext, pdfContext=_pdfContext;

- (id)initWithDocument:(RKDocument *)document
{
    self = [self init];
    if (!self)
        return nil;
    
    // Initialize PDF context
    _pdfData = [NSMutableData new];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)_pdfData);
    CGRect mediaBox = document.pdfMediaBox;
    
    _pdfContext = CGPDFContextCreate(dataConsumer, &mediaBox, (__bridge CFDictionaryRef)document.pdfMetadata);
    #if TARGET_OS_MAC
    _nsPdfContext = [NSGraphicsContext graphicsContextWithGraphicsPort:_pdfContext flipped:NO];
    #endif
    
    // Initialize other references
    _document = document;
    _sections = [NSMutableArray new];

    _currentSectionNumber = NSUIntegerMax;
    _currentPageNumber = NSUIntegerMax;
    _currentColumnNumber = NSUIntegerMax;
    _pageNumberOfCurrentSection = NSUIntegerMax;
    
    _documentNotes = [NSMutableArray new];
    _sectionNotes = [NSMutableArray new];
    _pageNotes = [NSMutableArray new];
    
    _listEnumerator = [RKListEnumerator new];
    
    return self;
}

- (NSData *)close
{
    if (_pageNumberOfCurrentSection != NSUIntegerMax)
        CGPDFContextEndPage(_pdfContext);
    
    CGPDFContextClose(_pdfContext);
    return _pdfData;
}

- (void)insertSection:(RKSection *)section atIndex:(NSUInteger)index
{
    [_sections insertObject:section atIndex:index];
}

- (void)appendSection:(RKSection *)section
{
    [self insertSection:section atIndex:_sections.count];
}



#pragma mark - Sections and Pages

- (RKSection *)currentSection
{
    NSAssert(_currentSectionNumber < _sections.count, @"Invalid section");
    
    return _sections[_currentSectionNumber];
}

- (NSString *)stringForCurrentPageNumber
{
    return [self.currentSection stringForPageNumber: (self.currentPageNumber + 1)];
}

- (void)nextSection
{
    // Update page and section counter
    _pageNumberOfCurrentSection = NSUIntegerMax;
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


- (NSString *)enumeratorForNote:(NSAttributedString *)note isFootnote:(BOOL)isFootnote;
{
    RKNoteIndexType noteIndexType = (isFootnote) ? [self indexTypeForFootnotes] : [self indexTypeForEndnotes];
    NSMutableArray *noteIndex = [self noteIndexForType: noteIndexType];
    
    // Test, whether there is already a key
    for (NSDictionary *noteDescriptor in noteIndex) {
        if ([noteDescriptor[RKFootnoteContentKey] isEqual: note])
            return noteDescriptor[RKFootnoteEnumerationStringKey];
    }

    NSString *enumerationString;
    
    // Otherwise create an enumeration string
    if (isFootnote) {
        _footnoteCounter ++;
        enumerationString = [RKDocument footnoteMarkerForIndex:_footnoteCounter usingEnumerationStyle:self.document.footnoteEnumerationStyle];
    }
    else {
        _endnoteCounter ++;
        enumerationString = [RKDocument footnoteMarkerForIndex:_footnoteCounter usingEnumerationStyle:self.document.endnoteEnumerationStyle];
    }

    // Register note to index
    NSDictionary *noteDescriptor = @{
        RKFootnoteContentKey:               note,
        RKFootnoteEnumerationStringKey:     enumerationString
    };

    [noteIndex addObject: noteDescriptor];

    return enumerationString;
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



#pragma mark - Footnote rendering support

- (void)truncateHeadOfNoteIndex:(RKNoteIndexType)noteIndexType toIndex:(NSUInteger)truncationIndex
{
    NSMutableArray *noteIndex = [self noteIndexForType: noteIndexType];

    // Get footnote
    NSAttributedString *attributedString = noteIndex[0];
    if (!attributedString)
        return;
    
    // Just remove the footnote if truncated to 0
    if (attributedString.length <= truncationIndex) {
        [noteIndex removeObjectAtIndex: 0];
        return;
    }
        
    // Truncate the string
    attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(truncationIndex, attributedString.length - truncationIndex)];
    noteIndex[0] = attributedString;
}

@end
