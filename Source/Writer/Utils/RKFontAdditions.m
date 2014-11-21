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
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		defaultFont = CTFontCreateWithName(CFSTR("Helvetica"), 12, NULL);
	});
    
    return defaultFont;
}

#if !TARGET_OS_IPHONE

@implementation NSFont (RTFFontAdditions)

+ (NSFont *)RTFDefaultFont
{
    return [NSFont fontWithName:@"Helvetica" size:12];
}

@end

#else

@implementation UIFont (RTFFontAdditions)

+ (UIFont *)RTFDefaultFont
{
	return [UIFont fontWithName:@"Helvetica" size:12];
}

@end

#endif
