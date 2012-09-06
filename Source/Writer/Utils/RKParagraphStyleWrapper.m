//
//  RKParagraphStyleWrapper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyleWrapper.h"

#import "RKTextTabWrapper.h"

@implementation RKParagraphStyleWrapper

@synthesize textAlignment, firstLineHeadIndent, headIndent, tailIndent, tabStops, defaultTabInterval, lineBreakMode, lineHeightMultiple, maximumLineHeight, minimumLineHeight, lineSpacing, paragraphSpacing, paragraphSpacingBefore, baseWritingDirection, hyphenationFactor;

+ (RKParagraphStyleWrapper *)newDefaultParagraphStyle
{
    #if !TARGET_OS_IPHONE
        return [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: [NSParagraphStyle defaultParagraphStyle]];
    #else
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(NULL, 0);
        RKParagraphStyleWrapper *wrapper = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle: paragraphStyle];
        CFRelease(paragraphStyle);
    
        return wrapper;
    #endif
}

- (id)initWithCTParagraphStyle:(CTParagraphStyleRef)paragraphStyle
{
    self = [self init];
    
    if (self) {
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlignment);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore);
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &baseWritingDirection);

        // Convert tab stops
        NSMutableArray *rkTabStops = [NSMutableArray new];
        CFArrayRef ctTabStops = NULL;
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &ctTabStops);
        
        for (id ctTabStopObject in (__bridge NSArray *)ctTabStops) {
            RKTextTabWrapper *textTab = [[RKTextTabWrapper alloc] initWithCTTextTab:(__bridge CTTextTabRef)ctTabStopObject];
            [rkTabStops addObject: textTab];
        }
        
        tabStops = rkTabStops;
    }
    
    return self;
}

#if !TARGET_OS_IPHONE
- (id)initWithNSParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
    self = [self init];
    
    if (self) {
        textAlignment = paragraphStyle.alignment;
        firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
        headIndent = paragraphStyle.headIndent;
        tailIndent = paragraphStyle.tailIndent;
        
        #if !TARGET_OS_IPHONE
            defaultTabInterval = paragraphStyle.defaultTabInterval;
        #endif
        
        lineBreakMode = paragraphStyle.lineBreakMode;
        lineHeightMultiple = paragraphStyle.lineHeightMultiple;
        maximumLineHeight = paragraphStyle.maximumLineHeight;
        minimumLineHeight = paragraphStyle.minimumLineHeight;
        lineSpacing = paragraphStyle.lineSpacing;
        paragraphSpacing = paragraphStyle.paragraphSpacing;
        paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
        baseWritingDirection = paragraphStyle.baseWritingDirection;
        hyphenationFactor = paragraphStyle.hyphenationFactor;
     
        NSMutableArray *rkTabStops = [NSMutableArray new];
        
        for (NSTextTab *nsTextTab in paragraphStyle.tabStops) {
            [rkTabStops addObject: [[RKTextTabWrapper alloc] initWithNSTextTab: nsTextTab]];
        }
        
        tabStops = rkTabStops;
    }
    
    return self;
}
#endif

- (CTParagraphStyleRef)newCTParagraphStyle
{
    NSMutableArray *ctTabStops = [NSMutableArray new];
    
    for (RKTextTabWrapper *rkTextTab in self.tabStops) {
        [ctTabStops addObject:(__bridge id)rkTextTab.newCTTextTab];
    }
    
    CTParagraphStyleSetting settings[14] = {
        {.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (CTTextAlignment[]){ self.textAlignment }},
        {.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.firstLineHeadIndent }},
        {.spec = kCTParagraphStyleSpecifierHeadIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.headIndent }},
        {.spec = kCTParagraphStyleSpecifierTailIndent, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.tailIndent }},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (CTLineBreakMode[]){ self.lineBreakMode }},
        {.spec = kCTParagraphStyleSpecifierLineHeightMultiple, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.lineHeightMultiple }},
        {.spec = kCTParagraphStyleSpecifierMaximumLineHeight, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.maximumLineHeight }},
        {.spec = kCTParagraphStyleSpecifierMinimumLineHeight, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.minimumLineHeight }},
        {.spec = kCTParagraphStyleSpecifierLineSpacing, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.lineSpacing }},
        {.spec = kCTParagraphStyleSpecifierParagraphSpacing, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.paragraphSpacing }},
        {.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.paragraphSpacingBefore }},
        {.spec = kCTParagraphStyleSpecifierBaseWritingDirection, .valueSize = sizeof(CTWritingDirection), .value = (CTWritingDirection[]){ self.baseWritingDirection }},
        {.spec = kCTParagraphStyleSpecifierDefaultTabInterval, .valueSize = sizeof(CGFloat), .value = (CGFloat[]){ self.defaultTabInterval }},
        {.spec = kCTParagraphStyleSpecifierTabStops, .valueSize = sizeof(CFArrayRef), .value = (CFArrayRef[]){ (__bridge CFArrayRef)ctTabStops }},
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
    return paragraphStyle;
}

#if !TARGET_OS_IPHONE
- (NSParagraphStyle *)newNSParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.firstLineHeadIndent = self.firstLineHeadIndent;
    paragraphStyle.headIndent = self.headIndent;
    paragraphStyle.tailIndent = self.tailIndent;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
    paragraphStyle.maximumLineHeight = self.maximumLineHeight;
    paragraphStyle.minimumLineHeight = self.minimumLineHeight;
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    paragraphStyle.paragraphSpacingBefore = self.paragraphSpacingBefore;
    paragraphStyle.baseWritingDirection = self.baseWritingDirection;
    paragraphStyle.defaultTabInterval = self.defaultTabInterval;
    paragraphStyle.hyphenationFactor = self.hyphenationFactor;
    
    NSMutableArray *nsTabStops = [NSMutableArray new];
    
    for (RKTextTabWrapper *rkTabStop in tabStops) {
        [nsTabStops addObject: rkTabStop.newNSTextTab];
    }
    
    paragraphStyle.tabStops = nsTabStops;
    
    return paragraphStyle;
}
#endif

@end
