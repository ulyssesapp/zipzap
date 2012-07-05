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
 */
+ (NSUInteger)priority;

/*!
 @abstract (Abstract) Re-Renders the given attribute to the given context using the given text run
 */
+ (void)renderUsingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run;

@end
