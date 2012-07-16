//
//  RKPDFFrame.h
//  RTFKit
//
//  Created by Friedrich Gräter on 11.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract A frame layout
 */
@interface RKPDFFrame : NSObject

/*!
 @abstract Renders the given frame using the given range.
 @discussion Returns the bounding box of the actual rendered frame. Applies custom rendering methods for layout runs of RKTextRendererAttributeName. Executes the given block for each line of the frame allowing to stop rendering at an arbitrary line.
 */
- (void)renderWithRenderedRange:(NSRange *)renderedRangeOut renderedBoundingBox:(CGRect *)renderedBoundingBoxOut usingBlock:(void(^)(NSRange lineRange, BOOL *stop))block;

/*!
 @abstract The bounding box required to render the entire frame
 */
@property (nonatomic, readonly) CGRect boundingBox;

/*!
 @abstract The text range inside the source string used to render the frame
 */
@property (nonatomic, readonly) NSRange visibleStringRange;

@end
