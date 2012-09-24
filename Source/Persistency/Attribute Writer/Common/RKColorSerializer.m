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
    
    CGFloat red = [[propertyList objectForKey: RKColorRedComponentPersistenceKey] floatValue];
    CGFloat green = [[propertyList objectForKey: RKColorGreenComponentPersistenceKey] floatValue];
    CGFloat blue = [[propertyList objectForKey: RKColorBlueComponentPersistenceKey] floatValue];
    CGFloat alpha = [[propertyList objectForKey: RKColorAlphaComponentPersistenceKey] floatValue];
    
    #if !TARGET_OS_IPHONE
        return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
    #else
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorspace, (CGFloat[]){red, green, blue, alpha});
        CFRelease(colorspace);
    
        return (__bridge id)color;
    #endif

}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    CGColorRef color;
    
    #if !TARGET_OS_IPHONE
        color = [((NSColor *)attributeValue) CGColorUsingGenericRGBAColorSpace];
    #else
        color = (__bridge CGColorRef)attributeValue;
    #endif
    
    const CGFloat *components = CGColorGetComponents(color);
    
    NSDictionary *serializedColor = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat: components[0]], RKColorRedComponentPersistenceKey,
                                     [NSNumber numberWithFloat: components[1]], RKColorGreenComponentPersistenceKey,
                                     [NSNumber numberWithFloat: components[2]], RKColorBlueComponentPersistenceKey,
                                     [NSNumber numberWithFloat: components[3]], RKColorAlphaComponentPersistenceKey,
                                     nil];

    #if !TARGET_OS_IPHONE
        CFRelease(color);
    #endif
    
    return serializedColor;
}

@end
