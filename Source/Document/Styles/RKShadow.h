//
//  RKShadow.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
/*!
 @abstract Represents a text shadow
 @discussion Only available on iOS
 */
@interface RKShadow : NSObject

/*!
 @abstract The blur radius of the shadow
 */
@property (nonatomic) CGFloat shadowBlurRadius;

/*!
 @abstract The offset of the shadow
 */
@property (nonatomic) CGSize shadowOffset;

/*!
 @abstract The color of the shadow
 */
@property (nonatomic, strong) __attribute__((NSObject)) CGColorRef shadowColor;

@end
#endif
