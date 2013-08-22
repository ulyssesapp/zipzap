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

#if !TARGET_OS_IPHONE

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

#else

- (RKParagraphStyleWrapper *)wrappedParagraphStyleAtIndex:(NSUInteger)index
{
	RKParagraphStyleWrapper *paragraphStyle = nil;
	
	// Get paragraph style
	CTParagraphStyleRef ctParagraphStyle = (__bridge CTParagraphStyleRef)[[self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL] mutableCopy];
	
	// Use default paragraph style otherwise
	if (!ctParagraphStyle) {
		ctParagraphStyle = CTParagraphStyleCreate(NULL, 0);
		paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle:ctParagraphStyle];
		
		CFRelease(ctParagraphStyle);
	}
	
	paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle:ctParagraphStyle];
	CFRelease(ctParagraphStyle);
	
	return paragraphStyle:
}

- (void)updateParagraphStylesInRange:(NSRange)range usingBlock:(void (^)(NSRange range, RKParagraphStyleWrapper *))block
{
	[self.string enumerateSubstringsInRange:range options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		RKParagraphStyleWrapper *paragraphStyle = [self wrappedParagraphStyleAtIndex: enclosingRange.location];
		
		// Update paragraph style
		block(enclosingRange, paragraphStyle);
		
		CTParagraphStyleRef updatedStyle = paragraphStyle.newCTParagraphStyle;
		[self addAttribute:NSParagraphStyleAttributeName value:(__bridge id)updatedStyle range:range];
		
		CFRelease(updatedStyle);
	}];
}

#endif

@end
