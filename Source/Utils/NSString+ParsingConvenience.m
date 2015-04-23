//
//  NSString+ParsingConvenience.m
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "NSString+ParsingConvenience.h"

@implementation NSString (ParsingConvenience)

- (void)enumerateTokensWithDelimiters:(NSCharacterSet *)set inRange:(NSRange)range usingBlock:(void(^)(NSRange tokenRange, unichar delimiter))block
{
	NSParameterAssert(block != nil);
	
	NSUInteger scanLocation = range.location;
	
	do {
		NSRange delimiterRange = [self rangeOfCharacterFromSet:set options:0 range:NSMakeRange(scanLocation, NSMaxRange(range) - scanLocation)];
		NSRange tokenRange = (delimiterRange.length == 0) ? NSMakeRange(scanLocation, NSMaxRange(range) - scanLocation) : NSMakeRange(scanLocation, delimiterRange.location -scanLocation);
		
		unichar delimiter = (delimiterRange.length == 0) ?: [self characterAtIndex: delimiterRange.location];
		
		block(tokenRange, delimiter);
		
		scanLocation = NSMaxRange(delimiterRange);
	} while (scanLocation < NSMaxRange(range));
}

@end
