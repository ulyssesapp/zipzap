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
#import "RKPDFWriter.h"

@implementation RKDocument

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
        #if !TARGET_OS_IPHONE
            NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];

            self.pageSize = printInfo.paperSize;
            self.pageInsets = RKPageInsetsMake(printInfo.topMargin, printInfo.leftMargin, printInfo.rightMargin, printInfo.bottomMargin);
        #elif TARGET_OS_IPHONE
            self.pageSize = CGSizeMake(595, 842);
            self.pageInsets = RKPageInsetsMake(90, 72, 72, 90);
        #endif

        self.pageOrientation = RKPageOrientationPortrait;
        self.hyphenationEnabled = NO;
        
        self.footnoteEnumerationPolicy = RKFootnoteEnumerationPerPage;
        self.endnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RKDocument *copy = [RKDocument allocWithZone: zone];
    
    copy.sections = [self.sections copy];
    copy.metadata = [self.metadata copy];

    copy.hyphenationEnabled = _hyphenationEnabled;
    copy.pageSize = _pageSize;
    copy.pageInsets = _pageInsets;
    copy.pageOrientation = _pageOrientation;
    copy.footnotePlacement = _footnotePlacement;
    copy.endnotePlacement = _endnotePlacement;
    copy.footnoteEnumerationStyle = _footnoteEnumerationStyle;
    copy.endnoteEnumerationStyle = _endnoteEnumerationStyle;
    copy.footnoteEnumerationPolicy = _footnoteEnumerationPolicy;
    copy.endnoteEnumerationPolicy = _endnoteEnumerationPolicy;

    copy.paragraphStyles = [_paragraphStyles copy];
    copy.characterStyles = [_characterStyles copy];
    
    return copy;
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
    
    return [self initWithSections: @[[RKSection sectionWithContent: string]]];
}

@end

@implementation RKDocument (Exporting)

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

- (NSData *)PDF
{
    return [RKPDFWriter PDFFromDocument: self];
}

@end

@implementation RKDocument (TestingSupport)

BOOL RKDocumentIsUsingRandomListIdentifier = YES;

+ (void)useRandomListIdentifiers:(BOOL)useRandomListIdentifier
{
    RKDocumentIsUsingRandomListIdentifier = useRandomListIdentifier;
}

+ (BOOL)isUsingRandomListIdentifier
{
    return RKDocumentIsUsingRandomListIdentifier;
}

@end
