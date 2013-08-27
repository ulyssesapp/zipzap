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

#import "NSString+RKNumberFormatting.h"

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
		_locale = [NSLocale currentLocale];
        
        _footnoteEnumerationPolicy = RKFootnoteEnumerationPerPage;
        _endnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;
        
        // Set header / footer spacing to RTF default
        _headerSpacingBefore = 36;
		_headerSpacingAfter = 10;
		_footerSpacingBefore = 10;
        _footerSpacingAfter = 36;
		
		_footnoteSpacingBefore = 15;
	
		_pageBinding = RKPageBindingNone;
		_pageGutterWidth = 0;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RKDocument *copy = [RKDocument allocWithZone: zone];
    
    copy.sections = [self.sections copy];
    copy.metadata = [self.metadata copy];

    copy.hyphenationEnabled = _hyphenationEnabled;
	copy.locale = _locale;
    copy.pageSize = _pageSize;
    copy.pageInsets = _pageInsets;
    copy.pageOrientation = _pageOrientation;
    copy.footnotePlacement = _footnotePlacement;
    copy.endnotePlacement = _endnotePlacement;
    copy.footnoteEnumerationStyle = _footnoteEnumerationStyle;
    copy.endnoteEnumerationStyle = _endnoteEnumerationStyle;
    copy.footnoteEnumerationPolicy = _footnoteEnumerationPolicy;
    copy.endnoteEnumerationPolicy = _endnoteEnumerationPolicy;
    copy.headerSpacingBefore = _headerSpacingBefore;
    copy.headerSpacingAfter = _headerSpacingAfter;
    copy.footerSpacingBefore = _footerSpacingBefore;
	copy.footerSpacingAfter = _footerSpacingAfter;
    copy.sectionNumberingStyle = _sectionNumberingStyle;
	copy.pageBinding = _pageBinding;
	copy.pageGutterWidth = _pageGutterWidth;
    
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
			&&  [self.locale.localeIdentifier isEqual: object.locale.localeIdentifier]
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
            &&  (self.headerSpacingBefore == object.headerSpacingBefore)
            &&  (self.headerSpacingAfter == object.headerSpacingAfter)
            &&  (self.footerSpacingBefore == object.footerSpacingBefore)
            &&  (self.footerSpacingAfter == object.footerSpacingAfter)
			&&  (self.pageBinding == object.pageBinding)
			&&  (self.pageGutterWidth == object.pageGutterWidth)
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

+ (NSString *)footnoteMarkerForIndex:(NSUInteger)index usingEnumerationStyle:(RKFootnoteEnumerationStyle)enumerationStyle
{
    switch (enumerationStyle) {
        case RKFootnoteEnumerationAlphabeticLowerCase:
            return [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationAlphabeticUpperCase:
            return [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationRomanLowerCase:
            return [NSString lowerCaseRomanNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationRomanUpperCase:
            return [NSString upperCaseRomanNumeralsFromUnsignedInteger: index];
            
        case RKFootnoteEnumerationDecimal:
            return [NSString stringWithFormat:@"%lu", index];
            
        case RKFootnoteEnumerationChicagoManual:
            return [NSString chicagoManualOfStyleNumeralsFromUnsignedInteger: index];
    }
    
}

@end

@implementation RKDocument (Exporting)

- (NSData *)wordRTF
{
    return [RKWriter wordRTFfromDocument: self];
}

- (NSData *)systemRTF
{
    return [RKWriter systemRTFfromDocument: self];
}

- (NSFileWrapper *)RTFD
{
    return [RKWriter RTFDfromDocument: self];    
}

- (NSData *)PDF
{
#if !TARGET_OS_IPHONE
    return [RKPDFWriter PDFFromDocument:self options:0];
#else
	NSAssert(NO, @"PDF not implemented on iOS.");
	return nil;
#endif
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
