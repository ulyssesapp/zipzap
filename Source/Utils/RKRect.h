//
//  RKRect.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract An object wrapper for CGRect
 */
@interface RKRect : NSObject

/*!
 @abstract Creates a new rect using a CGRect
 */
+ (RKRect *)rectWithRect:(CGRect)rect;

/*!
 @abstract Initializes a rect wit ha CGRect
 */
- (id)initWithRect:(CGRect)rect;

/*!
 @abstract The wrapped CGRect
 */
@property (nonatomic, readonly) CGRect rectValue;

@end
