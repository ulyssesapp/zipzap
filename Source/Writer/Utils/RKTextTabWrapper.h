//
//  RKTextTabWrapper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Allows to wrap a CTTextTab for more convenient usage
 */
@interface RKTextTabWrapper : NSObject

/*!
 @abstract Initializes the wrapper with the given paragraph style
 */
- (id)initWithCTTextTab:(CTTextTabRef)textTab;

/*!
 @abstract Initializes the wrapper with the given paragraph style
 */
- (id)initWithNSTextTab:(NSTextTab *)textTab;

/*!
 @abstract Creates a new paragraph style based on the settings of the wrapper
 */
- (CTTextTabRef)newCTTextTab;

/*!
 @abstract Creates a new paragraph style based on the settings of the wrapper
 */
- (NSTextTab *)newNSTextTab;

/*!
 @abstract Designated initializer.
 */
- (id)initWithLocation:(CGFloat)location alignment:(CTTextAlignment)alignment;

/*!
 @abstract The tab alignment
 */
@property (nonatomic, readwrite) CTTextAlignment tabAlignment;

/*!
 @abstract The tab location
 */
@property (nonatomic, readwrite) CGFloat location;

@end
