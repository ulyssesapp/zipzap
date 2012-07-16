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
 */
+ (void)renderSection:(RKSection *)section usingContext:(RKPDFRenderingContext *)context;

@end

@implementation RKPDFWriter

+ (NSData *)PDFFromDocument:(RKDocument *)document
{
    RKPDFRenderingContext *context = [[RKPDFRenderingContext alloc] initWithDocument: document];
    
    // Convert all sections to core text representation
    for (RKSection *section in document.sections) {
        // Convert section
        RKSection *convertedSection = [section coreTextRepresentationUsingContext: context];
        [context appendSection: convertedSection];
    }
    
    // Apply rendering per section
    for (RKSection *section in context.sections) {
        [context nextSection];
        [self renderSection:section usingContext:context];
    }
    
    return [context close];
}

+ (void)renderSection:(RKSection *)section usingContext:(RKPDFRenderingContext *)context
{
    // Convert content string
    NSAttributedString *contentString = section.content;
    NSRange remainingRange = NSMakeRange(0, contentString.length);
    
    // Render pages
    while (remainingRange.length) {
        [context startNewPage];
        
        RKPageSelectionMask pageSelector = [section pageSelectorForContext: context];
        
        // Layout and render header
        NSAttributedString *headerString = [section headerForPage: pageSelector];
        CGRect headerConstraints = CGRectMake(0,0,0,0);
        
        if (headerString) {
            headerConstraints = [context.document boundingBoxForPageHeaderOfSection: section];
            RKPDFFrame *headerFrame = [RKFramesetter frameForAttributedString:headerString usingRange:NSMakeRange(0, headerString.length) rect:headerConstraints context:context];
            headerConstraints = headerFrame.visibleBoundingBox;
                        
            [headerFrame renderWithRenderedRange:NULL usingOrigin:headerFrame.boundingBox.origin block:nil];
        }

        // Layout and render footer
        NSAttributedString *footerString = [section footerForPage: pageSelector];
        CGRect footerConstraints = CGRectMake(0,0,0,0);
        
        if (footerString) {
            footerConstraints = [context.document boundingBoxForPageFooterOfSection: section];
            RKPDFFrame *footerFrame = [RKFramesetter frameForAttributedString:footerString usingRange:NSMakeRange(0, footerString.length) rect:footerConstraints context:context];
            footerConstraints = footerFrame.boundingBox;
            footerConstraints.origin.y = footerFrame.boundingBox.origin.y - footerFrame.boundingBox.size.height + footerFrame.visibleBoundingBox.size.height;

            [footerFrame renderWithRenderedRange:NULL usingOrigin:footerConstraints.origin block:nil];
        }

        // Calculate column constraints
        for (NSUInteger columnIndex = 0; columnIndex < section.numberOfColumns; columnIndex ++) {
            [context startNewColumn];
            
            CGRect columnBox = [context.document boundingBoxForColumn:columnIndex section:section withHeader:headerConstraints footer:footerConstraints];

            // Layout content
            NSRange renderedRange;
            RKPDFFrame *contentFrame = [RKFramesetter frameForAttributedString:contentString usingRange:remainingRange rect:columnBox context:context];
            
            [contentFrame renderWithRenderedRange:&renderedRange usingOrigin:columnBox.origin block:nil];
            remainingRange.location += renderedRange.length;
            remainingRange.length -= renderedRange.length;
        }
    }
}

@end
