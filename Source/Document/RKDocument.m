//
//  RKDocument.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"
#import "RKSection.h"
#import "RKWriter.h"

@implementation RKDocument

@synthesize sections, metadata, hyphenationEnabled, footnotePlacement, pageSize, pageInsets, pageOrientation;

+ (RKDocument *)documentWithSections:(NSArray *)initialSections
{
    return [[RKDocument alloc] initWithSections: initialSections];
}

+ (RKDocument *)documentWithAttributedString:(NSAttributedString *)string
{
    return [[RKDocument alloc] initWithAttributedString: string];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
        
        self.pageSize = [printInfo paperSize];
        self.pageInsets = (RKPageInsets){.top = [printInfo topMargin], 
                                         .left = [printInfo leftMargin], 
                                         .right = [printInfo rightMargin], 
                                         .bottom = [printInfo bottomMargin] 
                                        };

        self.pageOrientation = RKPageOrientationPortrait;
        self.hyphenationEnabled = NO;
    }
    
    return self;
}

- (id)initWithSections:(NSArray *)initialSections
{
    self = [self init];
    
    if (self) {
        self.sections = initialSections;
    }
    
    return self;
}

- (id)initWithAttributedString:(NSAttributedString *)string
{
    NSAssert(string != nil, @"Initialization string must not be nil");
    
    return [self initWithSections: [NSArray arrayWithObject: [RKSection sectionWithContent: string]]];
}

- (NSData *)RTF
{
    return [RKWriter RTFfromDocument: self];
}

/*!
 @abstract Exports the document as RTFD 
 @discussion Creates a file wrapper containing the RTF and all referenced pictures
 */
- (NSFileWrapper *)RTFD
{
    return [RKWriter RTFDfromDocument: self];    
}

@end
