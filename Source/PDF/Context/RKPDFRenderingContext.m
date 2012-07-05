//
//  RKPDFRenderingContext.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFRenderingContext.h"
#import "RKDocument+PDFUtilitites.h"

@interface RKPDFRenderingContext ()
{
    // The data of the generated PDF document
    NSMutableData *_pdfData;
    
    // The rendered sections
    NSMutableArray *_sections;
    
    // Indices of all text objects
    NSMutableDictionary *_textObjects;
}

@end


@implementation RKPDFRenderingContext

@synthesize sections=_sections;

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
    
    // Initialize other references
    _document = document;
    _sections = [document.sections mutableCopy];
    _textObjects = [NSMutableDictionary new];
    
    return self;
}

- (NSData *)close
{
    CGPDFContextClose(_pdfContext);
    return _pdfData;
}

- (void)insertSection:(RKSection *)section atIndex:(NSUInteger)index
{
    [_sections insertObject:section atIndex:index];
}

#pragma mark - Registration of text objects

- (void)registerTextObject:(RKPDFTextObject *)textObject forSection:(RKSection *)section withEnumerationPolicy:(RKPDFRenderingEnumerationPolicy)enumerationPolicy
{
    NSAssert(false, @"Not implemented yet");
}

- (NSUInteger)indexOfTextObject:(RKPDFTextObject *)textObject
{
    NSAssert(false, @"Not implemented yet");
    return 0;
}

- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName
{
    NSAssert(false, @"Not implemented yet");
    return nil;
}

- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName section:(RKSection *)section
{
    NSAssert(false, @"Not implemented yet");
    return nil;
}

- (NSDictionary *)textObjectsForAttributeName:(NSString *)attributeName section:(RKSection *)section page:(NSUInteger)page
{
    NSAssert(false, @"Not implemented yet");
    return nil;
}

- (void)nextSection
{
    NSAssert(false, @"Not implemented yet");
}

- (void)startNewPage
{
    NSAssert(false, @"Not implemented yet");
}

- (BOOL)startNewColumn
{
    NSAssert(false, @"Not implemented yet");
    return NO;
}

@end
