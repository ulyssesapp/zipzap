//
//  NSAttributedString+RKCalculationAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+RKCalculationAdditions.h"
#import "RKFontAdditions.h"

@implementation NSAttributedString (RKCalculationAdditions)

- (CGFloat)pointSizeInRange:(NSRange)range
{
    __block CGFloat pointSize = 0;
    
    [self enumerateAttribute:RKFontAttributeName inRange:range options:0 usingBlock:^(id fontRef, NSRange range, BOOL *stop) {
        CTFontRef font = (__bridge CTFontRef)fontRef;
        
        pointSize = fmax(pointSize, CTFontGetSize(font ?: RKGetDefaultFont()));
    }];
    
    return pointSize;
}

@end
