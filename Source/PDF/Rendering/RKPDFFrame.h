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
- (void)renderWithRenderedRange:(NSRange *)renderedRangeOut usingOrigin:(CGPoint)origin block:(void(^)(NSRange lineRange, CGRect lineBoundingBox, NSUInteger lineIndex, BOOL *stop))block;

/*!
 @abstract The bounding box surrounding the visible part of the frame
 */
@property (nonatomic, readonly) CGRect visibleBoundingBox;

/*!
 @abstract The bounding box required to render the entire frame
 */
@property (nonatomic, readonly) CGRect boundingBox;

/*!
 @abstract The text range inside the source string used to render the frame
 */
@property (nonatomic, readonly) NSRange visibleStringRange;

/*!
 @abstract The full bounding boxes for all lines
 @discussion NSValue of NSRect
 */
@property (nonatomic, readonly) NSArray *lineRects;

/*!
 @abstract The bounding boxes for all lines (without descent; the box ranges from the base line to the ascent of the line)
 @discussion NSValue of NSRect
 */
@property (nonatomic, readonly) NSArray *lineRectsWithoutDescent;


@end
