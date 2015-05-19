//
//  NSXMLElement+IntegerValueConvenience.m
//  RTFKit
//
//  Created by Lucas Hauswald on 15.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "NSXMLElement+IntegerValueConvenience.h"

@implementation NSXMLElement (IntegerValueConvenience)

+ (NSXMLElement *)attributeWithName:(NSString *)name integerValue:(NSInteger)integerValue
{
	return [self attributeWithName:name stringValue:@(integerValue).stringValue];
}

@end
