//
//  RKColorPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKColorCoreTextConverter.h"

#import "RKConversion.h"
#import "RKPDFBackgroundColorRenderer.h"
#import "RKPDFTextDecorationRenderer.h"

#import "NSAttributedString+PDFCoreTextConversion.h"
#import "NSAttributedString+PDFUtilities.h"

@interface RKColorCoreTextConverter ()

/*!
 @abstract Converts the given color attribute inside the mutable attributed string to a core text color attribute. If required the given renderer is installed.
 */
+ (void)convertColorAttributeWithName:(NSString *)attributeName inAttributedString:(NSMutableAttributedString *)attributedString toCoreTextAttribute:(NSString *)newAttributeName usingRenderer:(Class)renderer;

@end

@implementation RKColorCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    
    [self convertColorAttributeWithName:NSForegroundColorAttributeName inAttributedString:converted toCoreTextAttribute:(__bridge id)kCTForegroundColorAttributeName usingRenderer:nil];
    [self convertColorAttributeWithName:NSBackgroundColorAttributeName inAttributedString:converted toCoreTextAttribute:RKPDFBackgroundColorAttributeName usingRenderer:RKPDFBackgroundColorRenderer.class];
    [self convertColorAttributeWithName:RKUnderlineColorAttributeName inAttributedString:converted toCoreTextAttribute:RKPDFRendererUnderlineColorAttributeName usingRenderer:nil];
    [self convertColorAttributeWithName:NSStrokeColorAttributeName inAttributedString:converted toCoreTextAttribute:(__bridge id)kCTStrokeColorAttributeName usingRenderer:nil];
    [self convertColorAttributeWithName:RKStrikethroughColorAttributeName inAttributedString:converted toCoreTextAttribute:RKPDFRendererStrikethroughColorAttributeName usingRenderer:nil];

    return converted;
}

+ (void)convertColorAttributeWithName:(NSString *)attributeName inAttributedString:(NSMutableAttributedString *)attributedString toCoreTextAttribute:(NSString *)newAttributeName usingRenderer:(Class)renderer
{
    [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id color, NSRange range, BOOL *stop) {
        if (!color)
            return;
                
        // Set color attribute
#if !TARGET_OS_IPHONE
        CGColorRef convertedColor = [color newCGColorUsingGenericRGBColorSpace];
#else
		CGColorRef convertedColor = [color CGColor];
#endif
        [attributedString addAttribute:newAttributeName value:(__bridge id)convertedColor range:range];

#if !TARGET_OS_IPHONE
		// Only required on Mac, since CGColor returns an autoreleased object
		CGColorRelease(convertedColor);
#endif
		
        // Use a renderer, if given
        if (renderer)
            [attributedString addTextRenderer:renderer forRange:range];
    }];
}

@end