//
//  RKPredefinedStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPredefinedStyle.h"

NSString *RKPredefinedCharacterStyleAttributeName = @"RKCharacterStyle";
NSString *RKPredefinedParagraphStyleAttributeName = @"RKParagraphStyle";

@implementation NSMutableAttributedString (RKAttributedStringPredefinedStyleConvenience)

- (void)addPredefinedCharacterStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKPredefinedCharacterStyleAttributeName value:styleSheetName range:range];
}

- (void)addPredefinedParagraphStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKPredefinedParagraphStyleAttributeName value:styleSheetName range:range];    
}

- (void)applyPredefinedCharacterStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range
{
    [self addPredefinedCharacterStyleAttribute:styleSheetName range:range];
    [self addAttributes:[document.characterStyles objectForKey:styleSheetName] range:range];
}

- (void)applyPredefinedParagraphStyleAttribute:(NSString *)styleSheetName document:(RKDocument *)document range:(NSRange)range
{
    [self addPredefinedParagraphStyleAttribute:styleSheetName range:range];
    [self addAttributes:[document.paragraphStyles objectForKey:styleSheetName] range:range];
}

@end
