//
//  RKFramesetter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFramesetter.h"

#import "RKPDFTextObject.h"
#import "RKPDFFrame+PrivateFramesetterMethods.h"

#import "NSAttributedString+PDFUtilities.h"

@interface RKFramesetter ()

/*!
 @abstract Estimates the range of text visible in the given attributes string
 @discussion This estimation is an upper bound since text objects have not been translated to their final representation
 */
+ (NSRange)estimatedVisibleRangeForAttributedString:(NSAttributedString *)attributedString  usingRange:(NSRange)range rect:(CGRect)rect;

/*!
 @abstract Creates a new attributed string by replacing all text objects by their context-specific, final representation
 @discussion Passes out an array with the ranges of all former text objects that can be used to re-translate string ranges
 */
+ (NSAttributedString *)instantiateTextObjectOfAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range context:(RKPDFRenderingContext *)context textObjectRanges:(NSArray **)ranges;

@end

@implementation RKFramesetter

#pragma mark - Frame rendering

+ (RKPDFFrame *)frameForAttributedString:(NSAttributedString *)attributedString usingRange:(NSRange)range rect:(CGRect)rect context:(RKPDFRenderingContext *)context
{
    // Estimate upper bound range for layout
    NSRange upperBoundRange = [self estimatedVisibleRangeForAttributedString:attributedString usingRange:range rect:rect];
    
    // Translate text objects
    NSArray *textObjectRanges;
    NSAttributedString *layoutedString = [self instantiateTextObjectOfAttributedString:attributedString inRange:upperBoundRange context:context textObjectRanges:&textObjectRanges];
    
    // Layout string
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)layoutedString);
    CGPathRef rectPath = CGPathCreateWithRect(rect, NULL);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, layoutedString.length), rectPath, NULL);

    RKPDFFrame *frame = [[RKPDFFrame alloc] initWithFrame:ctFrame attributedString:layoutedString sourceRange:upperBoundRange textObjectRanges:textObjectRanges context:context];
    
    // Free memory
    CFRelease(rectPath);
    CFRelease(framesetter);
    CFRelease(ctFrame);
    
    return frame;
}

+ (NSRange)estimatedVisibleRangeForAttributedString:(NSAttributedString *)attributedString  usingRange:(NSRange)range rect:(CGRect)rect
{
    // Estimate the length of attributed string that actually has to be layed out
    CTFramesetterRef estimationFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CFRange fitRange;
    
    CTFramesetterSuggestFrameSizeWithConstraints(estimationFramesetter, CFRangeMake(range.location, range.length), NULL, rect.size, &fitRange);
    
    CFRelease(estimationFramesetter);
    
    return NSMakeRange(fitRange.location, fitRange.length);
}

+ (NSAttributedString *)instantiateTextObjectOfAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range context:(RKPDFRenderingContext *)context textObjectRanges:(NSArray **)ranges
{
    // Translate text objects
    NSMutableArray *textObjectRanges = [NSMutableArray new];
    NSMutableAttributedString *translateableString = [[attributedString attributedSubstringFromRange: range] mutableCopy];
    
    __block NSUInteger offset = 0;
    
    [attributedString enumerateAttribute:RKTextObjectAttributeName inRange:range options:0 usingBlock:^(RKPDFTextObject *textObject, NSRange range, BOOL *stop) {
        if (!textObject)
            return;
        
        // Translate text object
        NSAttributedString *translatedTextObject = [textObject replacementStringUsingContext:context attributedString:attributedString atIndex:range.location];
        [translateableString replaceCharactersInRange:NSMakeRange(range.location + offset, range.length) withAttributedString:translatedTextObject];
        [translateableString addTextObjectAttribute:textObject atIndex:range.location];
        
        [textObjectRanges addObject: [NSValue valueWithRange: NSMakeRange(range.location + offset, translatedTextObject.length)]];
        
        offset += translatedTextObject.length - range.length;
    }];

    return translateableString;
}

@end
