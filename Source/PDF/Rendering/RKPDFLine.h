//
//  RKPDFLine.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract A renderable line
 */
@interface RKPDFLine : NSObject

/*!
 @abstract Initializes a new line with its bounding box (without descent)
 */
- (id)initWithBoundingBox:(CGRect)boundingBox ascent:(CGFloat)ascent descent:(CGFloat)descent leading:(CGFloat)leading range:(NSRange)range;

/*!
 @abstract The bounding box around the line without descent (absolute coordinates)
 */
@property (nonatomic, readonly) CGRect boundingBox;

/*!
 @abstract The line recht with descent (absolute coordinates)
 */
@property (nonatomic, readonly) CGRect boundingBoxWithoutDescent;

/*!
 @abstract The ascent height of the line
 */
@property (nonatomic, readonly) CGFloat ascent;

/*!
 @abstract The descent height of the line
 */
@property (nonatomic, readonly) CGFloat descent;

/*!
 @abstract The leading whitespace of the line
 */
@property (nonatomic, readonly) CGFloat leading;

/*!
 @abstract The range of the source string that belongs to the line
 */
@property (nonatomic, readonly) NSRange range;


@end
