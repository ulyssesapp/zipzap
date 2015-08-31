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
		_headerLevel = 0;
		_skipOrphanControl = NO;
		_justifyLineBreaks = NO;
	}
	
	return self;
}

- (BOOL)isEqual:(RKAdditionalParagraphStyle *)object
{
	return	   [object isKindOfClass: RKAdditionalParagraphStyle.class]
			&& (self.headerLevel == object.headerLevel)
			&& (self.keepWithFollowingParagraph == object.keepWithFollowingParagraph)
			&& (self.skipOrphanControl == object.skipOrphanControl)
			&& (self.hyphenationEnabled == object.hyphenationEnabled)
			&& (self.baselineDistance == object.baselineDistance)
			&& (self.overrideLineHeightAndSpacing == object.overrideLineHeightAndSpacing)
			&& (self.justifyLineBreaks == object.justifyLineBreaks);
}

- (NSUInteger)hash
{
	return 1;
}

- (id)copyWithZone:(NSZone *)zone
{
	RKAdditionalParagraphStyle *newStyle = [RKAdditionalParagraphStyle new];
	newStyle.headerLevel = self.headerLevel;
	newStyle.keepWithFollowingParagraph = self.keepWithFollowingParagraph;
	newStyle.hyphenationEnabled = self.hyphenationEnabled;
	newStyle.skipOrphanControl = self.skipOrphanControl;
	newStyle.baselineDistance = self.baselineDistance;
	newStyle.overrideLineHeightAndSpacing = self.overrideLineHeightAndSpacing;
	newStyle.justifyLineBreaks = self.justifyLineBreaks;
	
	return newStyle;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"RKAdditionalParagraphStyle: ("
											"headerLevel:					%lu, "
											"keepWithFollowingParagraph:	%d, "
											"hyphenationEnabled:			%u, "
											"baselineDistance:				%f, "
										    "overrideLineHeightAndSpacing:	%d, "
											"skipOrphanControl:				%u, "
											"justifyLineBreaks:				%u"
										")",
			(unsigned long)self.headerLevel,
			self.keepWithFollowingParagraph,
			self.hyphenationEnabled,
			self.baselineDistance,
			self.overrideLineHeightAndSpacing,
			self.skipOrphanControl,
			self.justifyLineBreaks
			];
}

@end
