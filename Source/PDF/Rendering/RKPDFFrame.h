//
//  RKPDFFrame.h
//  RTFKit
//
//  Created by Friedrich Gräter on 11.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriterTypes.h"

@class RKPDFRenderingContext;

/*!
 @abstract A frame layout
 */
@interface RKPDFFrame : NSObject

/*!
 @abstract Renders the given frame
 @discussion See renderLines: usingOrigin: options:
 */
- (void)renderUsingOrigin:(CGPoint)origin options:(RKPDFWriterRenderingOptions)options;

/*!
 @abstract Renders the given frame upto the given line.
 @discussion Applies custom rendering methods for layout runs of RKTextRendererAttributeName. 
 */
- (void)renderLines:(NSUInteger)lineCount usingOrigin:(CGPoint)origin options:(RKPDFWriterRenderingOptions)options;

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
 @abstract The lines of the frame (array of RKPDFLine)
 */
@property (nonatomic, readonly) NSArray *lines;

@end
