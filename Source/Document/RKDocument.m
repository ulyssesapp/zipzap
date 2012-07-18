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

            _pageSize = printInfo.paperSize;
            _pageInsets = RKPageInsetsMake(printInfo.topMargin, printInfo.leftMargin, printInfo.rightMargin, printInfo.bottomMargin);
        #elif TARGET_OS_IPHONE
            _pageSize = CGSizeMake(595, 842);
            _pageInsets = RKPageInsetsMake(90, 72, 72, 90);
        #endif

        _pageOrientation = RKPageOrientationPortrait;
        _hyphenationEnabled = NO;
        
        _footnoteEnumerationPolicy = RKFootnoteEnumerationPerPage;
        _endnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;

        // Set header / footer spacing to RTF default
        _headerSpacing = 36;
        _footerSpacing = 36;
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
    copy.headerSpacing = _headerSpacing;
    copy.footerSpacing = _footerSpacing;

    copy.paragraphStyles = [_paragraphStyles copy];
    copy.characterStyles = [_characterStyles copy];
    
    return copy;
}

- (BOOL)isEqual:(RKDocument*)object
{
    if (![object isKindOfClass: RKDocument.class])
        return false;
    
    return      [self.sections isEqual: object.sections]
            &&  [self.metadata isEqual: object.metadata]
            &&  [self.paragraphStyles isEqual: object.paragraphStyles]
            &&  [self.characterStyles isEqual: object.characterStyles]    
            &&  (self.hyphenationEnabled == object.hyphenationEnabled)
            &&  (self.pageSize.width == object.pageSize.width)
            &&  (self.pageSize.height == object.pageSize.height)
            &&  (self.pageInsets.top == object.pageInsets.top)
            &&  (self.pageInsets.left == object.pageInsets.left)
            &&  (self.pageInsets.right == object.pageInsets.right)
            &&  (self.pageInsets.bottom == object.pageInsets.bottom)
            &&  (self.pageOrientation == object.pageOrientation)
            &&  (self.footnotePlacement == object.footnotePlacement)
            &&  (self.endnotePlacement == object.endnotePlacement)
            &&  (self.footnoteEnumerationStyle == object.footnoteEnumerationStyle)
            &&  (self.endnoteEnumerationStyle == object.endnoteEnumerationStyle)
            &&  (self.footnoteEnumerationPolicy == object.footnoteEnumerationPolicy)
            &&  (self.endnoteEnumerationPolicy == object.endnoteEnumerationPolicy)
            &&  (self.headerSpacing == object.headerSpacing)
            &&  (self.footerSpacing == object.footerSpacing)    
    ;
}

- (id)initWithSections:(NSArray *)initialSections
{
    self = [self init];
    
    if (self) {
        _sections = initialSections;
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
    return [RKPDFWriter PDFFromDocument:self options:0];
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
