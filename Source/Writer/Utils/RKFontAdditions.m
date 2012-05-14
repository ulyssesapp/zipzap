//
//  RKFontAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFontAdditions.h"

CTFontRef RKGetDefaultFont(void)
{
    static CTFontRef defaultFont;
    defaultFont = (defaultFont) ?: CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL);
    
    return defaultFont;
}
