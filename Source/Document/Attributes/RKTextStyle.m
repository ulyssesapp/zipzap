//
//  RKTextStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextStyle.h"

NSString *RKPredefinedCharacterStyleAttributeName = @"RKCharacterStyle";
NSString *RKPredefinedParagraphStyleAttributeName = @"RKParagraphStyle";

@implementation NSMutableAttributedString (RKAttributedStringTextStyleConvenience)

- (void)addCharacterStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKPredefinedCharacterStyleAttributeName value:styleSheetName range:range];
}

- (void)addParagraphStyleAttribute:(NSString *)styleSheetName range:(NSRange)range
{
    [self addAttribute:RKPredefinedParagraphStyleAttributeName value:styleSheetName range:range];    
}

@end
