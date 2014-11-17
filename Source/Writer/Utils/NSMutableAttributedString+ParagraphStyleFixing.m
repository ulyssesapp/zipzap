//
//  NSMutableAttributedString+ParagraphStyleFixing.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "NSMutableAttributedString+ParagraphStyleFixing.h"

@implementation NSMutableAttributedString (ParagraphStyleFixing)

- (void)updateParagraphStylesInRange:(NSRange)range usingBlock:(void (^)(NSRange range, NSMutableParagraphStyle *))block
{
	[self.string enumerateSubstringsInRange:range options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		NSMutableParagraphStyle *paragraphStyle = [[self attribute:NSParagraphStyleAttributeName atIndex:enclosingRange.location effectiveRange:NULL] mutableCopy] ?: [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		
		block(enclosingRange, paragraphStyle);
		
		// Update attribute
		[self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:enclosingRange];
	}];
}

@end
