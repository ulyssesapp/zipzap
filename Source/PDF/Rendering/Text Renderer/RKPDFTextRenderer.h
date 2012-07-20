//
//  RKPDFTextRenderer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract Methods used for text attributes requiring special rendering
 */
@interface RKPDFTextRenderer : NSObject

/*!
 @abstract (Abstract) Provides a priority level for the text renderer among other renderers
 @discussion Negative Priorities are rendered before the actual text is rendered. Positive priorities will be rendered after the actual run. 
 */
+ (NSInteger)priority;

/*!
 @abstract (Abstract) Re-Renders the given attribute to the given context using the given text run
 */
+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect;

@end
