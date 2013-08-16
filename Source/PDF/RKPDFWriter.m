//
//  RKPDFWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriter.h"

#import "RKPDFRenderingContext.h"
#import "RKDocument.h"
#import "RKPDFFrame.h"
#import "RKPDFColumn.h"
#import "RKPDFLine.h"

#import "RKSection+PDFCoreTextConversion.h"
#import "RKSection+PDFUtilities.h"
#import "RKDocument+PDFUtilities.h"
#import "NSAttributedString+PDFUtilities.h"
#import "NSAttributedString+PDFCoreTextConversion.h"

@interface RKPDFWriter ()

/*!
 @abstract Renders a section using the given context
 @discussion If the section is the last section of the document, document endnotes are extended to the section
 */
+ (void)renderSection:(RKSection *)section usingContext:(RKPDFRenderingContext *)context isLastSection:(BOOL)isLastSection options:(RKPDFWriterRenderingOptions)options;

@end

@implementation RKPDFWriter

+ (NSData *)PDFFromDocument:(RKDocument *)document options:(RKPDFWriterRenderingOptions)options
{
    RKPDFRenderingContext *context = [[RKPDFRenderingContext alloc] initWithDocument: document];
    
    // Convert all sections to core text representation
    for (RKSection *section in document.sections) {
        // Convert section
        RKSection *convertedSection = [section coreTextRepresentationUsingContext: context];
        [context appendSection: convertedSection];
    }
    
    // Apply rendering per section
    [context.sections enumerateObjectsUsingBlock:^(RKSection *section, NSUInteger sectionIndex, BOOL *stop) {
        [context nextSection];
        [self renderSection:section usingContext:context isLastSection:(sectionIndex == (context.sections.count - 1)) options:options];
    }];
    
    return [context close];
}

+ (void)renderSection:(RKSection *)section usingContext:(RKPDFRenderingContext *)context isLastSection:(BOOL)isLastSection options:(RKPDFWriterRenderingOptions)options
{
    // Convert content string
    NSAttributedString *contentString = section.content;
    NSRange remainingContentRange = NSMakeRange(0, contentString.length);
    
    // Render pages as long we have text or footnotes
    NSAttributedString *footnotesForLastColumn = nil;
	NSRange remainingFootnotesRange = NSMakeRange(0, 0);
	BOOL endnotesAppended = NO;
	
    while (remainingContentRange.length || remainingFootnotesRange.length) {
        [context startNewPage];
        
        RKPageSelectionMask pageSelector = [section pageSelectorForContext: context];
        
        // Layout and render header
        NSAttributedString *headerString = [section headerForPage: pageSelector];
        CGRect headerConstraints = CGRectMake(0,0,0,0);
        
        if (headerString) {
            // Get upper bound for the bounding box of the header
            headerConstraints = [context.document boundingBoxForPageHeaderOfSection: section];
            
            // Layout header and calculate exact position
            RKPDFFrame *headerFrame = [[RKPDFFrame alloc] initWithRect:headerConstraints growingDirection:NO context:context];
			[headerFrame appendAttributedString:headerString inRange:NSMakeRange(0, headerString.length) usingWidowWidth:0 block:nil];
            headerConstraints = headerFrame.visibleBoundingBox;
            
            // Render header
            [headerFrame renderUsingOptions:options];
        }

        // Layout and render footer
        NSAttributedString *footerString = [section footerForPage: pageSelector];
        CGRect footerConstraints = CGRectMake(0,0,0,0);
        
        if (footerString) {
            // Get upper bound for the bounding box of the footer
            footerConstraints = [context.document boundingBoxForPageFooterOfSection: section];
            
            // Layout header and calculate exact position
            RKPDFFrame *footerFrame = [[RKPDFFrame alloc] initWithRect:footerConstraints growingDirection:YES context:context];
			[footerFrame appendAttributedString:footerString inRange:NSMakeRange(0, footerString.length) usingWidowWidth:0 block:nil];
            footerConstraints = footerFrame.visibleBoundingBox;

            // Render footer
            [footerFrame renderUsingOptions:options];
        }

        // Render columns
        for (NSUInteger columnIndex = 0; columnIndex < section.numberOfColumns; columnIndex ++) {
            [context startNewColumn];

            // Get column constraints and the constraints of the succeeding column for widow control
            CGRect columnBox = [context.document boundingBoxForColumn:columnIndex section:section withHeader:headerConstraints footer:footerConstraints];
            CGRect nextColumnBox = [context.document boundingBoxForColumn:((columnIndex >= section.numberOfColumns) ? 0 : columnIndex + 1) section:section withHeader:headerConstraints footer:footerConstraints];
            
			// Create column
			RKPDFColumn *column = [[RKPDFColumn alloc] initWithRect:columnBox widowWidth:nextColumnBox.size.width context:context];
			
			// Add remaining footnotes from last columns
			if (remainingFootnotesRange.length)
				[column appendFootnotes: footnotesForLastColumn];
			
			// Add content
			if (remainingContentRange.length)
				[column appendContent:contentString inRange:remainingContentRange];

			// Append endnotes, if required
			BOOL isLastPartOfSection = ((remainingContentRange.location + column.contentFrame.visibleStringLength) >= contentString.length);
			if (!endnotesAppended && isLastPartOfSection) {
				NSAttributedString *endnotes = nil;
				NSMutableArray *endnoteStrings = [NSMutableArray new];
				
				// Collect endnotes for section and document
				[endnoteStrings addObjectsFromArray: context.sectionNotes];
				if (isLastSection)
					[endnoteStrings addObjectsFromArray: context.documentNotes];
				
				// Generate endnote string and append it to the column
				endnotes = [NSAttributedString noteListFromNotes: endnoteStrings];
				[column appendFootnotes:endnotes];
				
				[context flushSectionNotes];
				
				endnotesAppended = YES;
			}
		
            // Render column
			[column renderWithOptions: options];
			
			// Calculate the remaining content range
			if (column.contentFrame.lines.count) {
				remainingContentRange.location += column.contentFrame.visibleStringLength;
				remainingContentRange.length = contentString.length - remainingContentRange.location;
			}
			
			// Get the actual remaining footnotes
			if (column.footnotesFrame.lines.count) {
				remainingFootnotesRange.location = column.visibleFootnotesLength;
				remainingFootnotesRange.length = column.footnotes.length - remainingFootnotesRange.location;
				footnotesForLastColumn = [column.footnotes attributedSubstringFromRange: remainingFootnotesRange];
			}
        }
    }
}

@end
