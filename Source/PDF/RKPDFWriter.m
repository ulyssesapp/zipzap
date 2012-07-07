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

#import "RKSection+PDFCoreTextConversion.h"
#import "RKSection+PDFUtilities.h"
#import "NSAttributedString+PDFUtilities.h"

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
        [self renderSection:section usingContext:context];
    }
    
    return [context close];
}

+ (void)renderSection:(RKSection *)section usingContext:(RKPDFRenderingContext *)context
{
    
}

@end
