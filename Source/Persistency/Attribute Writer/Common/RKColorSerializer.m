//
//  RKColorSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKColorSerializer.h"
#import "RKConversion.h"

NSString *RKColorRedComponentPersistenceKey = @"red";
NSString *RKColorGreenComponentPersistenceKey = @"green";
NSString *RKColorBlueComponentPersistenceKey = @"blue";
NSString *RKColorAlphaComponentPersistenceKey = @"alpha";


@implementation RKColorSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKBackgroundColorAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKForegroundColorAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKUnderlineColorAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrikethroughColorAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrokeColorAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    CGFloat red = [[propertyList objectForKey: RKColorRedComponentPersistenceKey] doubleValue];
    CGFloat green = [[propertyList objectForKey: RKColorGreenComponentPersistenceKey] doubleValue];
    CGFloat blue = [[propertyList objectForKey: RKColorBlueComponentPersistenceKey] doubleValue];
    CGFloat alpha = [[propertyList objectForKey: RKColorAlphaComponentPersistenceKey] doubleValue];
    
    #if !TARGET_OS_IPHONE
        return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
    #else
		return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    #endif

}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    CGColorRef color;
    
    #if !TARGET_OS_IPHONE
        color = [((NSColor *)attributeValue) newCGColorUsingGenericRGBAColorSpace];
    #else
        color = [(UIColor *)attributeValue CGColor];
    #endif
    
    const CGFloat *components = CGColorGetComponents(color);
    
    NSDictionary *serializedColor = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithDouble: components[0]], RKColorRedComponentPersistenceKey,
                                     [NSNumber numberWithDouble: components[1]], RKColorGreenComponentPersistenceKey,
                                     [NSNumber numberWithDouble: components[2]], RKColorBlueComponentPersistenceKey,
                                     [NSNumber numberWithDouble: components[3]], RKColorAlphaComponentPersistenceKey,
                                     nil];

#if !TARGET_OS_IPHONE
	// Only required on Mac, since CGColor returns an autoreleased object
	CGColorRelease(color);
#endif
	
    return serializedColor;
}

@end
