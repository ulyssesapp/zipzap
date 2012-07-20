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
#import "RKFramesetter.h"
#import "RKPDFFrame.h"

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

/*!
 @abstract Renders a column using the given attributed string inside the given range
 @discussion The column is defined by the given bounding box and rendered on behalf the given context. The method may receive footnotes from previous contexts. After its execution it provides the actually rendered range of the given string and all footnotes that did not have been rendered. Endnotes are automatically attached to the column. If the column is part of the last section of the document, also document endnotes are attached.
 */
+ (NSRange)renderColumnWithAttributedString:(NSAttributedString *)contentString inRange:(NSRange)contentRange boundingBox:(CGRect)columnBox context:(RKPDFRenderingContext *)context previousFootnotes:(NSAttributedString *)previousFootnotes remainingFootnotes:(NSAttributedString **)remainingFootnotesOut isLastSection:(BOOL)isLastSection options:(RKPDFWriterRenderingOptions)options;

/*!
 @abstract Appends document and section endnotes to the given list of footnotes.
 @discussion Document endnotes are only appended if 'isLastSection' is true. The notes are taken from the given context.
 */
+ (NSArray *)appendEndnotesToNotes:(NSArray *)notes isLastSection:(BOOL)isLastSection context:(RKPDFRenderingContext *)context;

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
    NSRange remainingRange = NSMakeRange(0, contentString.length);
    
    // Render pages as long we have text or footnotes
    __block NSAttributedString *remainingFootnotes = nil;
    
    while (remainingRange.length || remainingFootnotes.length) {
        [context startNewPage];
        
        RKPageSelectionMask pageSelector = [section pageSelectorForContext: context];
        
        // Layout and render header
        NSAttributedString *headerString = [section headerForPage: pageSelector];
        CGRect headerConstraints = CGRectMake(0,0,0,0);
        
        if (headerString) {
            // Get upper bound for the bounding box of the header
            headerConstraints = [context.document boundingBoxForPageHeaderOfSection: section];
            
            // Layout header and calculate exact position
            RKPDFFrame *headerFrame = [RKFramesetter frameForAttributedString:headerString usingRange:NSMakeRange(0, headerString.length) rect:headerConstraints context:context];
            headerConstraints = headerFrame.visibleBoundingBox;
            
            // Render header
            [headerFrame renderWithRenderedRange:NULL usingOrigin:headerFrame.boundingBox.origin options:options block:nil];
        }

        // Layout and render footer
        NSAttributedString *footerString = [section footerForPage: pageSelector];
        CGRect footerConstraints = CGRectMake(0,0,0,0);
        
        if (footerString) {
            // Get upper bound for the bounding box of the footer
            footerConstraints = [context.document boundingBoxForPageFooterOfSection: section];
            
            // Layout footer and calculate exact position
            RKPDFFrame *footerFrame = [RKFramesetter frameForAttributedString:footerString usingRange:NSMakeRange(0, footerString.length) rect:footerConstraints context:context];
            footerConstraints = footerFrame.boundingBox;
            footerConstraints.origin.y = footerFrame.boundingBox.origin.y - footerFrame.boundingBox.size.height + footerFrame.visibleBoundingBox.size.height;

            // Render footer
            [footerFrame renderWithRenderedRange:NULL usingOrigin:footerConstraints.origin options:options block:nil];
        }

        // Render columns
        for (NSUInteger columnIndex = 0; columnIndex < section.numberOfColumns; columnIndex ++) {
            [context startNewColumn];
            
            // Get column constraints
            CGRect columnBox = [context.document boundingBoxForColumn:columnIndex section:section withHeader:headerConstraints footer:footerConstraints];

            // Render column
            NSRange renderedRange = [self renderColumnWithAttributedString:contentString inRange:remainingRange boundingBox:columnBox context:context previousFootnotes:remainingFootnotes remainingFootnotes:&remainingFootnotes isLastSection:isLastSection options:options];
            
            // Update remaining text range
            remainingRange.location += renderedRange.length;
            remainingRange.length -= renderedRange.length;
        }
    }
}

+ (NSRange)renderColumnWithAttributedString:(NSAttributedString *)contentString inRange:(NSRange)contentRange boundingBox:(CGRect)columnBox context:(RKPDFRenderingContext *)context previousFootnotes:(NSAttributedString *)previousFootnotes remainingFootnotes:(NSAttributedString **)remainingFootnotesOut isLastSection:(BOOL)isLastSection options:(RKPDFWriterRenderingOptions)options
{
    // Create a prelimary layout the contents of the frame
    RKPDFFrame *contentFrame = [RKFramesetter frameForAttributedString:contentString usingRange:contentRange rect:columnBox context:context];

    NSRange renderedRange;
    __block NSMutableAttributedString *renderableFootnotes = [previousFootnotes mutableCopy] ?: [NSMutableAttributedString new];
    __block RKPDFFrame *footnoteFrame = [RKFramesetter frameForAttributedString:renderableFootnotes usingRange:NSMakeRange(0, renderableFootnotes.length) rect:columnBox context:context];

    __block BOOL pendingPageBreak = NO;
    
    // Render text lines
    [contentFrame renderWithRenderedRange:&renderedRange usingOrigin:columnBox.origin options:options block:^(NSRange lineRange, CGRect lineBoundingBox, NSUInteger lineIndex, BOOL *stop) {
        // Skip this line, if we have a pending page break
        if (pendingPageBreak) {
            *stop = YES;
            return;
        }
        
        // Get the maximum space we can occupy for footnotes unitl the current line (occupy the entire box wihtout spacings, if we are at line 0)
        CGRect footnoteBox = [context.document boundingBoxForFootnotesFromColumnRect:columnBox height:(lineBoundingBox.origin.y - columnBox.origin.y)];

        // Get footnotes for current line
        NSArray *currentFootnotes = [context registeredPageNotesInAttributedString:contentString range:lineRange];

        // Add endnotes to the footnotes, if we are on the last line of the column
        if ((lineRange.location + lineRange.length) >= contentString.length) {
            currentFootnotes = [self appendEndnotesToNotes:currentFootnotes isLastSection:isLastSection context:context];
        }

        // Create an attributed string for the footnote section (consisting of previous footnotes and the current footnotes)
        NSAttributedString *currentFootnoteString = [NSAttributedString noteListFromNotes: currentFootnotes];
        
        NSMutableAttributedString *estimatedFootnotes = [renderableFootnotes mutableCopy];
        if (currentFootnoteString.length) {
            if (estimatedFootnotes.length)
                [estimatedFootnotes appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];

            [estimatedFootnotes appendAttributedString: currentFootnoteString];
        }
        
        // Estimate, whether we can render the current line together with at least the beginning of its first footnote
        RKPDFFrame *currentFootnoteFrame = [RKFramesetter frameForAttributedString:estimatedFootnotes usingRange:NSMakeRange(0, estimatedFootnotes.length) rect:footnoteBox context:context];
        NSRange visibleFootnoteRange = currentFootnoteFrame.visibleStringRange;

        // If the current footnote box does not contain the additional footnotes of the current line, we can skip the line
        // We can also skip the line, if the new footnote frame is smaller than the last one
        if ((currentFootnoteString.length && (visibleFootnoteRange.length < renderableFootnotes.length)) || (footnoteFrame.visibleStringRange.length > currentFootnoteFrame.visibleStringRange.length)) {
            *stop = YES;
            return;
        }

        // Continue with the new footnote string
        footnoteFrame = currentFootnoteFrame;
        renderableFootnotes = estimatedFootnotes;
        
        // Did the current line propose a page break? If yes: stop after this line
        if ([contentString.string rangeOfString:@"\f" options:0 range:lineRange].length == 1)
            pendingPageBreak = YES;
    }];
    
    // Render footnotes and determine remaining footnote string
    NSAttributedString *remainingFootnotes = nil;

    if (footnoteFrame && footnoteFrame.visibleStringRange.length) {
        // Calculate position for footnotes on the bottom of the column
        CGRect originalFootnoteBox = footnoteFrame.boundingBox;
        CGRect visibleFootnoteBox = footnoteFrame.visibleBoundingBox;
        CGRect displacedFootnoteBox = originalFootnoteBox;
        displacedFootnoteBox.origin.y = originalFootnoteBox.origin.y - originalFootnoteBox.size.height + visibleFootnoteBox.size.height;
        
        // Render footnotes
        [footnoteFrame renderWithRenderedRange:NULL usingOrigin:displacedFootnoteBox.origin options:options block:nil];

        // Draw separator
        [context.document drawFootnoteSeparatorForBoundingBox:displacedFootnoteBox toContext:context];
        
        // Determine remaining footnote string
        NSRange visibleRange = footnoteFrame.visibleStringRange;
        
        if (visibleRange.length < renderableFootnotes.length)
            remainingFootnotes = [renderableFootnotes attributedSubstringFromRange:NSMakeRange(visibleRange.length, renderableFootnotes.length - visibleRange.length)];
    }

    if (remainingFootnotesOut)
        *remainingFootnotesOut = remainingFootnotes;
    
    // We return the range we've rendered so far from the current column
    return renderedRange;
}

+ (NSArray *)appendEndnotesToNotes:(NSArray *)notes isLastSection:(BOOL)isLastSection context:(RKPDFRenderingContext *)context
{
    NSMutableArray *allNotes = notes ? [notes mutableCopy] : [NSMutableArray new];
    
    // Add section notes
    if (context.sectionNotes)
        [allNotes addObjectsFromArray: context.sectionNotes];
    
    // Add document notes, if we are in the last section
    if (isLastSection) {
        if (context.documentNotes)
            [allNotes addObjectsFromArray: context.documentNotes];
    }
    
    return allNotes;
}

@end
