//
//  NSString+Hyphenation.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+Hyphenation.h"

@implementation NSMutableString (Hyphenation)

- (BOOL)insertHyphenationCharacter:(NSString *)hyphenationCharacter forLocale:(NSLocale *)locale inRange:(NSRange)range
{
	if (!locale.supportsHyphenation)
		return NO;
		
	// Enumerate words inside string
	[self enumerateSubstringsInRange:range options:NSStringEnumerationByWords usingBlock:^(NSString *word, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		CFStringRef cfWord = (__bridge CFStringRef)word;
		CFIndex beforeLocation = word.length;
		
		while (beforeLocation > 0) {
			beforeLocation = CFStringGetHyphenationLocationBeforeIndex(cfWord, beforeLocation, CFRangeMake(0, word.length), 0, (__bridge CFLocaleRef)locale, NULL);
			
			if (beforeLocation == kCFNotFound)
				break;
			
			[self insertString:hyphenationCharacter atIndex:substringRange.location + beforeLocation];
		}
	}];
	
	return YES;
}

@end

@implementation NSString (Hyphenation)

- (NSString *)stringByHyphenatingWithCharacter:(NSString *)hyphenationCharacter locale:(NSLocale *)locale inRange:(NSRange)range
{
	NSMutableString *mutableString = [self mutableCopy];
	[mutableString insertHyphenationCharacter:hyphenationCharacter forLocale:locale inRange:range];
	
	return mutableString;
}

@end

@implementation NSLocale (Hyphenation)

- (BOOL)supportsHyphenation
{
	return CFStringIsHyphenationAvailableForLocale((__bridge CFLocaleRef)self);
}

@end
