//
//  RKPDFFrame+PrivateFramesetterMethods.h
//  RTFKit
//
//  Created by Friedrich Gräter on 11.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFFrame.h"

@class RKPDFRenderingContext;

/*!
 @abstract Methods used to generate a frame by a framesetter
 */
@interface RKPDFFrame ()

/*!
 @abstract Initializes a frame with a CTFrame. All ranges used inside the frame are relative to the given source range. Also the ranges of all expanded text objects must be passed. It is assumed that every text object range corresponds to a single-charracter range in the source string.
 */
- (id)initWithFrame:(CTFrameRef)frame attributedString:(NSAttributedString *)attributedString sourceRange:(NSRange)range textObjectRanges:(NSArray *)textObjectRanges context:(RKPDFRenderingContext *)context;

/*!
 @abstract Translates a range of an attributed string with translated text objects to the source range using the text object range list of the frame
 */
- (NSRange)sourceRangeForRange:(NSRange)translatedRange;

@end
