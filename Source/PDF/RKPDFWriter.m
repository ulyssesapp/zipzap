//
//  RKPDFWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriter.h"

#import "RKPDFRenderingContext.h"

@implementation RKPDFWriter

+ (NSData *)PDFFromDocument:(RKDocument *)document
{
    RKPDFRenderingContext *context = [[RKPDFRenderingContext alloc] initWithDocument: document];
    
    return [context close];
}

@end
