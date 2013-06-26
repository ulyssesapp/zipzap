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

- (BOOL)isEqual:(RKAdditionalParagraphStyle *)object
{
	return [object isKindOfClass: RKAdditionalParagraphStyle.class] && (self.keepWithFollowingParagraph == object.keepWithFollowingParagraph);
}

- (id)copyWithZone:(NSZone *)zone
{
	RKAdditionalParagraphStyle *newStyle = [RKAdditionalParagraphStyle new];
	newStyle.keepWithFollowingParagraph = self.keepWithFollowingParagraph;
	
	return newStyle;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"RKAdditionalParagraphStyle: ("
											"keepWithFollowingParagraph: %d"
										")",
			self.keepWithFollowingParagraph
			];
}

@end
