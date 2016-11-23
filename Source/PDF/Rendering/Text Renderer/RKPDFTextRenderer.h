//
//  RKPDFTextRenderer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext, RKPDFLine;

/*!
 @abstract A custom text attribute that is used to implement base line offsets.
 @discussion This is used, since NSBaselineOffsetAttributeName is not officially supported by CoreText. However, it seems to be implemented on OS X >10.12.
 */
extern NSString *RKPDFRendererBaselineOffsetAttributeName;

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
+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run line:(RKPDFLine *)line boundingBox:(CGRect)runRect;

@end
