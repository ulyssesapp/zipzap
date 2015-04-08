//
//  NSColor+RKColorExtensions.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "NSColor+RKColorExtensions.h"

@implementation NSColor (RKColorExtensions)

- (NSString *)hexRepresentation
{
	CGFloat redComponent, greenComponent, blueComponent;
	
	[self getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:NULL];
	uint32_t hexValue = (  (((int)round(redComponent	* 255)) << 16)
						 + (((int)round(greenComponent	* 255)) << 8)
						 + (((int)round(blueComponent	* 255)) << 0));
	
	return [NSString stringWithFormat: @"%06x", hexValue];
}

@end
