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

+ (RKDocument *)documentWithSections:(NSArray *)initialSections
{
    RKDocument *document = [[RKDocument alloc] initWithSections:initialSections];

    return document;
}

+(RKDocument *)documentWithAttributedString:(NSAttributedString *)string
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:string];
        
    return document;
}

- (id)initWithSections:(NSArray *)initialSections
{
     NSAssert(initialSections != nil, @"Sections used for initialization must not be nil");
    
    self = [self init];
    
    if (self) {
        self.sections = initialSections;
    }
    
    return self;
}

- (id)initWithAttributedString: (NSAttributedString *)string
{
    NSAssert(string != nil, @"Initialization string must not be nil");
    
    RKSection *section = [RKSection sectionWithContent: string];
    NSArray *initialSections = [NSArray arrayWithObject:section];

    return [self initWithSections:initialSections];
}

@end
