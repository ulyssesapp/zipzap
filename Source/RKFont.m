//
//  RKFont.h
//  RTFKit
//
//  Created by Friedrich Gräter on 22/06/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKFont.h"

#if !TARGET_OS_IPHONE
@implementation RKFont (Additions)

+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName;
{
	NSMutableArray *members = [NSMutableArray new];;
	
	for (NSArray *fontVariant in [NSFontManager.sharedFontManager availableMembersOfFontFamily: familyName])
		[members addObject: fontVariant.firstObject];
	
	return members;
}

@end
#endif
