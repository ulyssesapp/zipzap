//
//  RKParagraphStylePDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "RKParagraphStyleCoreTextConverter.h"

@implementation RKParagraphStyleCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSParagraphStyle *paragraphStyle, NSRange range, BOOL *stop) {
        if (!paragraphStyle)
            return;

        // Convert tab stops
        NSMutableArray *convertedtabStops = [NSMutableArray new];

        for (NSTextTab *tabStop in paragraphStyle.tabStops) {
            CTTextTabRef convertedTab = CTTextTabCreate(tabStop.alignment, tabStop.location, NULL);
            [convertedtabStops addObject: (__bridge id)convertedTab];
        }
        
        // Convert style settings
        CTParagraphStyleSetting setting[] = {
            {kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), (CTWritingDirection[]){paragraphStyle.baseWritingDirection}},
            {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), (CTTextAlignment[]){paragraphStyle.alignment}},
            {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), (CGFloat[]){paragraphStyle.headIndent}},
            {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), (CGFloat[]){paragraphStyle.firstLineHeadIndent}},
            {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), (CGFloat[]){paragraphStyle.tailIndent}},
            {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), (CGFloat[]){paragraphStyle.lineSpacing}},
            {kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), (CGFloat[]){paragraphStyle.lineHeightMultiple}},
            {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), (CGFloat[]){paragraphStyle.maximumLineHeight}},
            {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), (CGFloat[]){paragraphStyle.minimumLineHeight}},
            {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), (CGFloat[]){paragraphStyle.paragraphSpacing}},
            {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), (CGFloat[]){paragraphStyle.paragraphSpacingBefore}},
            {kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), (CGFloat[]){paragraphStyle.defaultTabInterval}},
            {kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), (CFArrayRef[]){(__bridge CFArrayRef)convertedtabStops}},
        };
        
        // Create paragraph style
        CTParagraphStyleRef convertedStyle = CTParagraphStyleCreate(setting, sizeof(setting) / sizeof(CTParagraphStyleSetting));
        
        [converted removeAttribute:NSParagraphStyleAttributeName range:range];
        [converted addAttribute:(__bridge id)kCTParagraphStyleAttributeName value:(__bridge id)convertedStyle range:range];
    }];

    return converted;
}

@end
