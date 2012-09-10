//
//  NSString+Hyphenation.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+Hyphenation.h"

@implementation NSString (Hyphenation)

- (NSString *)stringByHyphenatingWithCharacter:(NSString *)hyphenationCharacter locale:(NSLocale *)locale inRange:(NSRange)range
{
	NSMutableString *mutableString = [self mutableCopy];
	
	[mutableString enumerateHyphenationsInRange:range usingLocale:locale block:^(NSUInteger index, NSString *suggestedSeparator) {
		[mutableString insertString:hyphenationCharacter atIndex:index];
	}];
	
	return mutableString;
}

- (BOOL)enumerateHyphenationsInRange:(NSRange)range usingLocale:(NSLocale *)locale block:(void(^)(NSUInteger index, NSString *suggestedSeparator))block
{
	if (!locale.supportsHyphenation)
		return NO;
	
	// Enumerate words inside string
	[self enumerateSubstringsInRange:range options:NSStringEnumerationByWords usingBlock:^(NSString *word, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		CFStringRef cfWord = (__bridge CFStringRef)word;
		CFIndex beforeLocation = word.length;
		
		while (beforeLocation > 0) {
			UTF32Char suggestedSeparator;
			
			beforeLocation = CFStringGetHyphenationLocationBeforeIndex(cfWord, beforeLocation, CFRangeMake(0, word.length), 0, (__bridge CFLocaleRef)locale, &suggestedSeparator);
			
			if (beforeLocation == kCFNotFound)
				break;
			
			block(substringRange.location + beforeLocation, [NSString stringWithFormat:@"%C", (unichar)suggestedSeparator]);
		}
	}];
	
	return YES;
}

@end

@implementation NSLocale (Hyphenation)

- (BOOL)supportsHyphenation
{
	return CFStringIsHyphenationAvailableForLocale((__bridge CFLocaleRef)self);
}

@end
