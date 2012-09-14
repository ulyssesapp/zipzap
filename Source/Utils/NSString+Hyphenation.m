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

	// We default to the document locale
	__block NSString *currentLanguage = [locale objectForKey: NSLocaleLanguageCode];
	__block NSLocale *currentLocale = locale;
	
	// Enumerate sentences to detect locale
	[self enumerateSubstringsInRange:range options:NSStringEnumerationBySentences usingBlock:^(NSString *sentence, NSRange sentenceRange, NSRange enclosingRange, BOOL *stop) {
		// Detect the language of the current sentence
		NSString *sentenceLanguage = (__bridge_transfer NSString*)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)sentence, CFRangeMake(0, sentence.length > 100 ? 100 : sentence.length));
		
		// Switch the locale, if required
		if (sentenceLanguage && ![sentenceLanguage isEqual: currentLanguage]) {
			NSString *localeIdentifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleLanguageCode: sentenceLanguage}];
			if (localeIdentifier) {
				currentLocale = [[NSLocale alloc] initWithLocaleIdentifier: localeIdentifier];
				currentLanguage = sentenceLanguage;
			}
		}
		
		// Hyphenate words in sentence
		[self enumerateSubstringsInRange:sentenceRange options:NSStringEnumerationByWords usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
			CFStringRef cfWord = (__bridge CFStringRef)word;
			CFIndex beforeLocation = word.length;
			
			while (beforeLocation > 0) {
				UTF32Char suggestedSeparator;
				
				beforeLocation = CFStringGetHyphenationLocationBeforeIndex(cfWord, beforeLocation, CFRangeMake(0, word.length), 0, (__bridge CFLocaleRef)currentLocale, &suggestedSeparator);
				
				if (beforeLocation == kCFNotFound)
					break;
				
				block(wordRange.location + beforeLocation, [NSString stringWithFormat:@"%C", (unichar)suggestedSeparator]);
			}
		}];
		
		
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
