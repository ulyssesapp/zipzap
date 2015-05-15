//
//  RKImage.h
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
	#define RKImage UIImage
#else
	#define RKImage NSImage
#endif
