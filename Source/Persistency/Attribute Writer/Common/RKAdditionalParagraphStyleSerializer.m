//
//  RKAdvancedParagraphStyleSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 06.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyleSerializer.h"
#import "RKAdditionalParagraphStyle.h"

NSString *RKAdditionalParagraphStyleKeepWithFollowingParagraphKey = @"keepWithFollowingParagraph";
NSString *RKAdditionalParagraphStyleHyphenationEnabledKey = @"hyphenationEnabled";
NSString *RKAdditionalParagraphStyleBaselineDistanceKey = @"baselineDistance";
NSString *RKAdditionalParagraphStyleOverrideLineHeightAndSpacingKey = @"overrideLineHeightAndSpacing";

@implementation RKAdditionalParagraphStyleSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKAdditionalParagraphStyleAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(NSDictionary *)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
	RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
	paragraphStyle.keepWithFollowingParagraph = [[propertyList objectForKey: RKAdditionalParagraphStyleKeepWithFollowingParagraphKey] boolValue];
	paragraphStyle.hyphenationEnabled = [[propertyList objectForKey: RKAdditionalParagraphStyleHyphenationEnabledKey] boolValue];
	paragraphStyle.baseLineDistance = [propertyList[RKAdditionalParagraphStyleBaselineDistanceKey] doubleValue];
	paragraphStyle.overrideLineHeightAndSpacing = [propertyList[RKAdditionalParagraphStyleOverrideLineHeightAndSpacingKey] boolValue];
	
	return paragraphStyle;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(RKAdditionalParagraphStyle *)attributeValue context:(RKPersistenceContext *)context
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool: attributeValue.keepWithFollowingParagraph], RKAdditionalParagraphStyleKeepWithFollowingParagraphKey,
				[NSNumber numberWithBool: attributeValue.hyphenationEnabled], RKAdditionalParagraphStyleHyphenationEnabledKey,
				[NSNumber numberWithFloat: attributeValue.baseLineDistance], RKAdditionalParagraphStyleBaselineDistanceKey,
				[NSNumber numberWithBool: attributeValue.overrideLineHeightAndSpacing], RKAdditionalParagraphStyleOverrideLineHeightAndSpacingKey,
			nil];
}

@end
