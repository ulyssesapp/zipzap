//
//  RKAdditionalParagraphStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyle.h"

NSString *RKAdditionalParagraphStyleAttributeName = @"RKAdditionalParagraphStyle";

@implementation RKAdditionalParagraphStyle

- (id)init
{
	self = [super init];
	
	if (self) {
		_keepWithFollowingParagraph = NO;
		_hyphenationEnabled = NO;
		_overrideLineHeightAndSpacing = NO;
		_baselineDistance = 0;
		_skipOrphanControl = NO;
	}
	
	return self;
}

- (BOOL)isEqual:(RKAdditionalParagraphStyle *)object
{
	return	   [object isKindOfClass: RKAdditionalParagraphStyle.class]
			&& (self.keepWithFollowingParagraph == object.keepWithFollowingParagraph)
			&& (self.skipOrphanControl == object.skipOrphanControl)
			&& (self.hyphenationEnabled == object.hyphenationEnabled)
			&& (self.baselineDistance == object.baselineDistance)
			&& (self.overrideLineHeightAndSpacing == object.overrideLineHeightAndSpacing);
}

- (NSUInteger)hash
{
	return 1;
}

- (id)copyWithZone:(NSZone *)zone
{
	RKAdditionalParagraphStyle *newStyle = [RKAdditionalParagraphStyle new];
	newStyle.keepWithFollowingParagraph = self.keepWithFollowingParagraph;
	newStyle.hyphenationEnabled = self.hyphenationEnabled;
	newStyle.skipOrphanControl = self.skipOrphanControl;
	newStyle.baselineDistance = self.baselineDistance;
	newStyle.overrideLineHeightAndSpacing = self.overrideLineHeightAndSpacing;
	
	return newStyle;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"RKAdditionalParagraphStyle: ("
											"keepWithFollowingParagraph:	%d, "
											"hyphenationEnabled:			%u, "
											"baselineDistance:				%f, "
										    "overrideLineHeightAndSpacing:	%d, "
											"skipOrphanControl:				%u"
										")",
			self.keepWithFollowingParagraph,
			self.hyphenationEnabled,
			self.baselineDistance,
			self.overrideLineHeightAndSpacing,
			self.skipOrphanControl
			];
}

@end
