//
//  RKColor.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
	#define RKColor UIColor

	#import "UIColor+RKColorExtensions.h"
#else
	#define RKColor NSColor

	#import "NSColor+RKColorExtensions.h"
#endif
