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
#import "RKDOCXWriter.h"

#import "NSString+RKNumberFormatting.h"

@implementation RKDocument

- (id)init
{
    self = [super init];
    
    if (self) {
		_pageSize = CGSizeMake(595, 842);
		_pageInsets = RKPageInsetsMake(90, 72, 72, 90);

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
		
		_footnoteAreaAnchorAttributes = @{RKSuperscriptAttributeName: @1};
		_footnoteAreaDividerSpacingBefore = 15;
		_footnoteAreaDividerSpacingAfter = 15;
		_footnoteAreaDividerLength = 100;
		_footnoteAreaDividerWidth = 1;
		_footnoteAreaAnchorInset = 0;
		_footnoteAreaContentInset = 20;
		_footnoteAreaAnchorAlignment = RKTextAlignmentLeft;

		_pageBinding = RKPageBindingLeft;
		
		_defaultStyle = @{RKParagraphStyleAttributeName: NSParagraphStyle.defaultParagraphStyle};
    }
    
    return self;
}

- (instancetype)initWithSections:(NSArray *)initialSections
{
	self = [self init];
	
	if (self) {
		_sections = initialSections;
	}
	
	return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)string
{
	NSAssert(string != nil, @"Initialization string must not be nil");
	
	return [self initWithSections: @[[[RKSection alloc] initWithContent: string]]];
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
	copy.twoSided = _twoSided;
	copy.footnoteAreaAnchorAttributes = [_footnoteAreaAnchorAttributes copy];

	copy.footnoteAreaDividerSpacingBefore = _footnoteAreaDividerSpacingBefore;
	copy.footnoteAreaDividerSpacingAfter = _footnoteAreaDividerSpacingAfter;
	copy.footnoteAreaDividerPosition = _footnoteAreaDividerPosition;
	copy.footnoteAreaDividerLength = _footnoteAreaDividerLength;
	copy.footnoteAreaDividerWidth = _footnoteAreaDividerWidth;
	copy.footnoteAreaAnchorInset = _footnoteAreaAnchorInset;
	copy.footnoteAreaContentInset = _footnoteAreaContentInset;
	copy.footnoteAreaAnchorAlignment = _footnoteAreaAnchorAlignment;
    
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
            &&  (self.pageInsets.inner == object.pageInsets.inner)
            &&  (self.pageInsets.outer == object.pageInsets.outer)
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
			&&  (self.twoSided == object.twoSided)
			&&  ([self.footnoteAreaAnchorAttributes isEqual: object.footnoteAreaAnchorAttributes])
			&&  (self.footnoteAreaDividerSpacingBefore == object.footnoteAreaDividerSpacingBefore)
			&&  (self.footnoteAreaDividerSpacingAfter == object.footnoteAreaDividerSpacingAfter)
			&&  (self.footnoteAreaDividerPosition == object.footnoteAreaDividerPosition)
			&&  (self.footnoteAreaDividerLength == object.footnoteAreaDividerLength)
			&&  (self.footnoteAreaDividerWidth == object.footnoteAreaDividerWidth)
			&&  (self.footnoteAreaAnchorInset == object.footnoteAreaAnchorInset)
			&&  (self.footnoteAreaContentInset == object.footnoteAreaContentInset)
			&&  (self.footnoteAreaAnchorAlignment == object.footnoteAreaAnchorAlignment)
    ;
}

- (NSUInteger)hash
{
	return 1;
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

- (NSData *)DOCX
{
	return [RKDOCXWriter DOCXfromDocument: self];
}

- (NSData *)PDFWithOperationHandle:(RKOperationHandle *)handle
{
	return [RKPDFWriter PDFFromDocument:self withOperationHandle:handle options:0];
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
