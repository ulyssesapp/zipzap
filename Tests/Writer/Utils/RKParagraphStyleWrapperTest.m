//
//  RKParagraphStyleWrapperTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyleWrapperTest.h"

#import "RKParagraphStyleWrapper.h"

@implementation RKParagraphStyleWrapperTest

#if !TARGET_OS_IPHONE
- (void)testConversionOfNSParagraph
{
    NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle];
    RKParagraphStyleWrapper *wrapped = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: paragraphStyle];
    
    XCTAssertEqualObjects(paragraphStyle, wrapped.newNSParagraphStyle, @"Styles not equal");
}
#endif

- (void)testConversionOfCTParagraph
{
    CTTextTabRef ctTabStop = CTTextTabCreate(kCTTextAlignmentRight, 42, NULL);
    
    NSArray *ctTabStops = [NSArray arrayWithObject: (__bridge id)ctTabStop];
    
    CTParagraphStyleSetting settings[14] = {
        {.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (CTTextAlignment[]){ kCTJustifiedTextAlignment }},
        {.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 1 }},
        {.spec = kCTParagraphStyleSpecifierHeadIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 2 }},
        {.spec = kCTParagraphStyleSpecifierTailIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 3 }},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (CTLineBreakMode[]){ kCTLineBreakByTruncatingHead }},
        {.spec = kCTParagraphStyleSpecifierLineHeightMultiple, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 4 }},
        {.spec = kCTParagraphStyleSpecifierMaximumLineHeight, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 5 }},
        {.spec = kCTParagraphStyleSpecifierMinimumLineHeight, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 6 }},
        {.spec = kCTParagraphStyleSpecifierLineSpacing, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 7 }},
        {.spec = kCTParagraphStyleSpecifierParagraphSpacing, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 8 }},
        {.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 9 }},
        {.spec = kCTParagraphStyleSpecifierBaseWritingDirection, .valueSize = sizeof(CTWritingDirection), .value = (CTWritingDirection[]){ kCTWritingDirectionRightToLeft }},
        {.spec = kCTParagraphStyleSpecifierDefaultTabInterval, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ 10 }},
        {.spec = kCTParagraphStyleSpecifierTabStops, .valueSize = sizeof(CFArrayRef), .value = (CFArrayRef[]){ (__bridge CFArrayRef)ctTabStops }},
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));

    RKParagraphStyleWrapper *wrapped = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle: paragraphStyle];
    
    CTParagraphStyleRef reconvertedStyle = wrapped.newCTParagraphStyle;
    
    CTTextAlignment textAlignment;
    CGFloat firstLineHeadIndent;
    CGFloat headIndent;
    CGFloat tailIndent;
    CTLineBreakMode lineBreakMode;
    CGFloat lineHeightMultiple;
    CGFloat maximumLineHeight;
    CGFloat minimumLineHeight;
    CGFloat lineSpacing;
    CGFloat paragraphSpacing;
    CGFloat paragraphSpacingBefore;
    CTWritingDirection baseWritingDirection;
    CGFloat defaultTabInterval;    
    CFArrayRef tabStops;
    
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection);
    CTParagraphStyleGetValueForSpecifier(reconvertedStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops);

    XCTAssertEqual(textAlignment, kCTJustifiedTextAlignment, @"Invalid value converted");
    XCTAssertEqual(firstLineHeadIndent, (CGFloat)1, @"Invalid value converted");
    XCTAssertEqual(headIndent, (CGFloat)2, @"Invalid value converted");
    XCTAssertEqual(tailIndent, (CGFloat)3, @"Invalid value converted");
    XCTAssertEqual(lineBreakMode, kCTLineBreakByTruncatingHead, @"Invalid value converted");
    XCTAssertEqual(lineHeightMultiple, (CGFloat)4, @"Invalid value converted");
    XCTAssertEqual(maximumLineHeight, (CGFloat)5, @"Invalid value converted");
    XCTAssertEqual(minimumLineHeight, (CGFloat)6, @"Invalid value converted");
    XCTAssertEqual(lineSpacing, (CGFloat)7, @"Invalid value converted");
    XCTAssertEqual(paragraphSpacing, (CGFloat)8, @"Invalid value converted");
    XCTAssertEqual(paragraphSpacingBefore, (CGFloat)9, @"Invalid value converted");
    XCTAssertEqual(baseWritingDirection, kCTWritingDirectionRightToLeft, @"Invalid value converted");
    XCTAssertEqual(defaultTabInterval, (CGFloat)10, @"Invalid value converted");

    XCTAssertEqual(CFArrayGetCount(tabStops), (CFIndex)1, @"Invalid tab stops count");
    CTTextTabRef textTab = CFArrayGetValueAtIndex(tabStops, 0);
    XCTAssertEqual(CTTextTabGetAlignment(textTab), kCTTextAlignmentRight, @"Invalid value converted");
    XCTAssertEqual(CTTextTabGetLocation(textTab), (double)42, @"Invalid value converted");
    
    CFRelease(paragraphStyle);
    CFRelease(reconvertedStyle);
    CFRelease(ctTabStop);
}

@end
