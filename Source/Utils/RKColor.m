//
//  NSColor+RKColorExtensions.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKColor.h"

@implementation RKColor (RKColorExtensions)

+ (RKColor *)rk_colorWithHexRepresentation:(NSString *)string
{
	if (!string || string.length < 6)
		return nil;
	
	uint32_t hexValue = 0;
	[[NSScanner scannerWithString: string] scanHexInt: &hexValue];
	
	CGFloat red = (((hexValue & (0xFF << 16)) >> 16) / 255.);
	CGFloat green = (((hexValue & (0xFF << 8)) >> 8) / 255.);
	CGFloat blue = ((hexValue & 0xFF) / 255.);
	
#if !TARGET_OS_IPHONE
	return [[NSColor colorWithDeviceRed:red green:green blue:blue alpha:1] colorUsingColorSpaceName: NSDeviceRGBColorSpace];
#else
	return [UIColor colorWithRed:red green:green blue:blue alpha:1];
#endif
}

- (NSString *)rk_hexRepresentation
{
	CGFloat redComponent, greenComponent, blueComponent;
	
	[self getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:NULL];
	uint32_t hexValue = (  (((int)round(redComponent	* 255)) << 16)
						 + (((int)round(greenComponent	* 255)) << 8)
						 + ((int)round(blueComponent	* 255)));
	
	return [NSString stringWithFormat: @"%06x", hexValue];
}

@end
