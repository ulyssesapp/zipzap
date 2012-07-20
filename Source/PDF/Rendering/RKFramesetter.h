//
//  RKFramesetter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext, RKPDFFrame;

@interface RKFramesetter : NSObject

/*!
 @abstract Layouts the given attributed string to a frame which is bounded by the given rect.
 @discussion Respects the RKTextObjectAttributeName and RKTextRendererAttributeName. 
 */
+ (RKPDFFrame *)frameForAttributedString:(NSAttributedString *)attributedString usingRange:(NSRange)range rect:(CGRect)rect context:(RKPDFRenderingContext *)context;

@end
