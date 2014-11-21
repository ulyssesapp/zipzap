//
//  NSMutableAttributedString+ParagraphStyleWrapper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "NSMutableAttributedString+ParagraphStyleWrapper.h"
#import "RKParagraphStyleWrapper.h"

@implementation NSMutableAttributedString (ParagraphStyleWrapper)

- (RKParagraphStyleWrapper *)wrappedParagraphStyleAtIndex:(NSUInteger)index
{
	// Get paragraph style
	NSMutableParagraphStyle *nsParagraphStyle = [[self attribute:NSParagraphStyleAttributeName atIndex:index effectiveRange:NULL] mutableCopy];
	if (!nsParagraphStyle)
		nsParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	
	// Update paragraph style
	return [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: nsParagraphStyle];
}

- (void)updateParagraphStylesInRange:(NSRange)range usingBlock:(void (^)(NSRange range, RKParagraphStyleWrapper *))block
{
	[self.string enumerateSubstringsInRange:range options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		RKParagraphStyleWrapper *paragraphStyle = [self wrappedParagraphStyleAtIndex: enclosingRange.location];
		
		block(enclosingRange, paragraphStyle);
		
		// Update attribute
		[self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle.newNSParagraphStyle range:enclosingRange];
	}];
}

@end
