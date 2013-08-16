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

- (void)updateParagraphStyleInRange:(NSRange)range usingBlock:(void (^)(RKParagraphStyleWrapper *))block
{
    // Get paragraph style
    NSMutableParagraphStyle *nsParagraphStyle = [[self attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL] mutableCopy];
    if (!nsParagraphStyle)
        nsParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	
    // Update paragraph style
    RKParagraphStyleWrapper *paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: nsParagraphStyle];
    
    block(paragraphStyle);
    
    // Update attribute
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle.newNSParagraphStyle range:range];
}

#else

- (void)updateParagraphStyleInRange:(NSRange)range usingBlock:(void (^)(RKParagraphStyleWrapper *))block
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
    
    // Update paragraph style
	block(paragraphStyle);
	
    CTParagraphStyleRef updatedStyle = paragraphStyle.newCTParagraphStyle;
    [self addAttribute:NSParagraphStyleAttributeName value:(__bridge id)updatedStyle range:range];
    
    CFRelease(updatedStyle);
}

#endif

@end
