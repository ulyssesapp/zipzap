//
//  RKAttributedStringAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringAdditions.h"
#import "RKFontAdditions.h"

@implementation NSAttributedString (RKAttributedStringAdditions)

- (CGFloat)pointSizeInRange:(NSRange)range
{
    __block CGFloat lineHeight = 0;
    
    [self enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(NSFont *font, NSRange range, BOOL *stop) {
        if (font == nil)
            lineHeight = fmax(lineHeight, [NSFont RTFdefaultFont].pointSize );
        else
            lineHeight = fmax(lineHeight, font.pointSize);
    }];
    
    return lineHeight;
}

@end
