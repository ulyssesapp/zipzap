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

@synthesize sections, metadata, hyphenationEnabled, pageSize, pageInsets, pageOrientation,
            footnotePlacement, endnotePlacement, footnoteEnumerationStyle, endnoteEnumerationStyle, footnoteEnumerationPolicy, endnoteEnumerationPolicy,
            paragraphStyles, characterStyles;

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
        self.pageInsets = RKPageInsetsMake(printInfo.topMargin, printInfo.leftMargin, printInfo.rightMargin, printInfo.bottomMargin);

        self.pageOrientation = RKPageOrientationPortrait;
        self.hyphenationEnabled = NO;
        
        self.footnoteEnumerationPolicy = RKFootnoteEnumerationPerPage;
        self.endnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;
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

- (NSData *)plainRTF
{
    return [RKWriter plainRTFfromDocument: self];
}

- (NSFileWrapper *)RTFD
{
    return [RKWriter RTFDfromDocument: self];    
}

@end
