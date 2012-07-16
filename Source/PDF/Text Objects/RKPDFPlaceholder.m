//
//  RKPDFPlaceholder.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFPlaceholder.h"

#import "RKPDFRenderingContext.h"

@interface RKPDFPlaceholder ()
{
    RKPlaceholderType _placeholderType;
}

@end

@implementation RKPDFPlaceholder

@synthesize placeholderType=_placeholderType;

- (id)initWithPlaceholderType:(RKPlaceholderType)placeholderType
{
    self = [self init];
    
    if (self)
        _placeholderType = placeholderType;
    
    return self;
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run
{
    return;
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)index
{
    // Enumerate and register footnote
    NSString *placeholderValue;
    
    switch (self.placeholderType) {
        case RKPlaceholderPageNumber:
            placeholderValue = context.stringForCurrentPageNumber;
            break;
            
        case RKPlaceholderSectionNumber:
            placeholderValue = [NSString stringWithFormat: @"%lu", context.currentSectionNumber];
            break;
            
        default:
            NSAssert(false, @"Invalid placeholder type");
    }
    
    // Create a replacement string (using superscript)
    NSMutableAttributedString *replacementString = [[NSMutableAttributedString alloc] initWithString:placeholderValue attributes:[attributedString attributesAtIndex:index effectiveRange:NULL]];
    return replacementString;
}

@end
