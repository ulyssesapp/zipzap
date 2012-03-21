//
//  RKParagraphStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyle.h"
#import "RKTextTab.h"

@implementation RKParagraphStyle

@synthesize alignment, firstLineHeadIndent, headIndent, tailIndent, tabStops, defaultTabInterval, lineHeightMultiple, maximumLineHeight, minimumLineHeight, lineSpacing, paragraphSpacing, paragraphSpacingBefore, baseWritingDirection;

+ (RKParagraphStyle *)paragraphStyleFromCoreTextRepresentation:(CTParagraphStyleRef)paragraphStyle
{
    RKParagraphStyle *paragraphStyleObject = [[RKParagraphStyle alloc] init];
    
    CTWritingDirection baseWritingDirection;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection);
    paragraphStyleObject.baseWritingDirection = baseWritingDirection;
    
    CTTextAlignment textAlignment;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment);
    paragraphStyleObject.alignment = textAlignment;
    
    CGFloat headIndent;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
    paragraphStyleObject.headIndent = headIndent;
    
    CGFloat firstLineHeadIndent;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
    paragraphStyleObject.firstLineHeadIndent = firstLineHeadIndent;
    
    CGFloat tailIndent;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent);
    paragraphStyleObject.tailIndent = tailIndent;
    
    CGFloat lineSpacing;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing);
    paragraphStyleObject.lineSpacing = lineSpacing;
    
    CGFloat lineHeightMultiple;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple);
    paragraphStyleObject.lineHeightMultiple = lineHeightMultiple;
    
    CGFloat maximumLineHeight;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight);
    paragraphStyleObject.maximumLineHeight = maximumLineHeight;
    
    CGFloat minimumLineHeight;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight);
    paragraphStyleObject.minimumLineHeight = minimumLineHeight;
    
    CGFloat paragraphSpacingBefore;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore);
    paragraphStyleObject.paragraphSpacingBefore = paragraphSpacingBefore;
    
    CGFloat paragraphSpacing;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing);
    paragraphStyleObject.paragraphSpacing = paragraphSpacing;
    
    CGFloat defaultTabInterval;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval);
    paragraphStyleObject.defaultTabInterval = defaultTabInterval;
    
    CFArrayRef tabStops;
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CGFloat), &tabStops);

    if (tabStops) {
        NSMutableArray *convertedTabStops = [NSMutableArray new];
    
        for (id tabStopObject in (__bridge NSArray *)tabStops) {
            CTTextTabRef tabStop = (__bridge CTTextTabRef)tabStopObject;
            RKTextTab *convertedTabStop = [RKTextTab textTabFromCoreTextRepresentation: tabStop];
            
            [convertedTabStops addObject: convertedTabStop];
        }
        
        paragraphStyleObject.tabStops = convertedTabStops;
    }
    
    return paragraphStyleObject;
}

- (CTParagraphStyleRef)coreTextRepresentation
{
    NSMutableArray *convertedtabStops = [NSMutableArray new];
    
    for (RKTextTab *tab in self.tabStops) {
        [convertedtabStops addObject: (__bridge id)[tab coreTextRepresentation]];
    }
    
    CTParagraphStyleSetting setting[] = {
        {kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), (CTWritingDirection[]){self.baseWritingDirection}},
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), (CTTextAlignment[]){self.alignment}},
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), (CGFloat[]){self.headIndent}},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), (CGFloat[]){self.firstLineHeadIndent}},
        {kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), (CGFloat[]){self.tailIndent}},
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), (CGFloat[]){self.lineSpacing}},
        {kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), (CGFloat[]){self.lineHeightMultiple}},
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), (CGFloat[]){self.maximumLineHeight}},
        {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), (CGFloat[]){self.minimumLineHeight}},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), (CGFloat[]){self.paragraphSpacing}},
        {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), (CGFloat[]){self.paragraphSpacingBefore}},
        {kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), (CGFloat[]){self.defaultTabInterval}},
        {kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), (CFArrayRef[]){(__bridge CFArrayRef)convertedtabStops}},
    };
    
    return CTParagraphStyleCreate(setting, sizeof(setting) / sizeof(CTParagraphStyleSetting));
}

#if !TARGET_OS_IPHONE

+ (RKParagraphStyle *)paragraphStyleFromTargetSpecificRepresentation:(NSParagraphStyle *)paragraphStyle
{
    RKParagraphStyle *convertedParagraphStyle = [RKParagraphStyle new];
    NSMutableArray *convertedTabStops = [NSMutableArray new];
    
    convertedParagraphStyle.baseWritingDirection = paragraphStyle.baseWritingDirection;
    convertedParagraphStyle.alignment = paragraphStyle.alignment;
    convertedParagraphStyle.headIndent = paragraphStyle.headIndent;
    convertedParagraphStyle.firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    convertedParagraphStyle.tailIndent = paragraphStyle.tailIndent;
    convertedParagraphStyle.lineSpacing = paragraphStyle.lineSpacing;
    convertedParagraphStyle.lineHeightMultiple = paragraphStyle.lineHeightMultiple;
    convertedParagraphStyle.maximumLineHeight = paragraphStyle.maximumLineHeight;
    convertedParagraphStyle.minimumLineHeight = paragraphStyle.minimumLineHeight;
    convertedParagraphStyle.paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
    convertedParagraphStyle.paragraphSpacing = paragraphStyle.paragraphSpacing;
    convertedParagraphStyle.defaultTabInterval = paragraphStyle.defaultTabInterval;
    convertedParagraphStyle.tabStops = convertedTabStops;
    
    for (NSTextTab *tab in paragraphStyle.tabStops) {
        [convertedTabStops addObject: [RKTextTab textTabFromTargetSpecificRepresentation: tab]];
    }

    return convertedParagraphStyle;
}

- (id)targetSpecificRepresentation
{
    NSMutableArray *convertedTabStops = [NSMutableArray new];
    
    for (RKTextTab *tab in self.tabStops) {
        [convertedTabStops addObject: [[NSTextTab alloc] initWithType:tab.tabStopType location:tab.location]];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.baseWritingDirection = self.baseWritingDirection;
    paragraphStyle.alignment = self.alignment;
    paragraphStyle.headIndent = self.headIndent;
    paragraphStyle.firstLineHeadIndent = self.firstLineHeadIndent;
    paragraphStyle.tailIndent = self.tailIndent;
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
    paragraphStyle.maximumLineHeight = self.maximumLineHeight;
    paragraphStyle.minimumLineHeight = self.minimumLineHeight;
    paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    paragraphStyle.paragraphSpacingBefore = self.paragraphSpacingBefore;
    paragraphStyle.defaultTabInterval = self.defaultTabInterval;
    paragraphStyle.tabStops = convertedTabStops;
    
    return paragraphStyle;
}

#else

+ (RKParagraphStyle *)paragraphStyleFromTargetSpecificRepresentation:(id)paragraphStyle
{
    return [self.class paragraphStyleFromCoreTextRepresentation: (__bridge CTParagraphStyleRef)paragraphStyle];
}

- (id)targetSpecificRepresentation 
{
    return (__bridge id)[self coreTextRepresentation];
}
#endif


@end
