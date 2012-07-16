//
//  RKSection+PDFCoreTextConversion.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection+PDFCoreTextConversion.h"

#import "NSAttributedString+PDFCoreTextConversion.h"

@implementation RKSection (PDFCoreTextConversion)

- (RKSection *)coreTextRepresentationUsingContext:(RKPDFRenderingContext *)context
{
    RKSection *convertedSection = [self copy];
    
    // Convert content
    convertedSection.content = [self.content coreTextRepresentationUsingContext: context];
    
    // Convert header
    [self enumerateHeadersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *header) {
        [convertedSection setHeader:[header coreTextRepresentationUsingContext: context] forPages:pageSelector];
    }];
    
    // Convert footer
    [self enumerateFootersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *footer) {
        [convertedSection setFooter:[footer coreTextRepresentationUsingContext: context] forPages:pageSelector];
    }];
    
    return convertedSection;
}

@end
