//
//  RKColor.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
	#define RKColor UIColor
#else
	#define RKColor NSColor
#endif

@interface RKColor (RKColorExtensions)

/*!
 @abstract Creates a new color from the given RGB hex representation.
 */
+ (RKColor *)rk_colorWithHexRepresentation:(NSString *)string;

/*!
 @abstract Returns the hexadecimal value of the color.
 */
@property(nonatomic, readonly) NSString *rk_hexRepresentation;

@end
