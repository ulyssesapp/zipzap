//
//  RKFont.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
	#define RKFont UIFont
#else
	#define RKFont NSFont
#endif