//
//  RKDocument.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"
#import "RKSection.h"
#import "RKExport.h"

@implementation RKDocument

@synthesize sections, metadata, hyphenationEnabled, footnotePlacement, pageSize, pageInsets, pageOrientation;

+ (RKDocument *)simpleDocumentWithSections:(NSArray *)initialSections
{
    RKDocument *document = [[RKDocument alloc] initWithSections:initialSections];

    return document;
}

- (id)initWithSections:(NSArray *)initialSections
{
    self = [self init];
    
    if (self) {
        self.sections = initialSections;
    }
    
    return self;
}

@end
