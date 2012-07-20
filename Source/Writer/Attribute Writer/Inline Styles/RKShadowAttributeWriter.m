//
//  RKShadowAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKShadowAttributeWriter.h"
#import "RKConversion.h"

@implementation RKShadowAttributeWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKShadowAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    }
}


+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(id)shadowObject resources:(RKResourcePool *)resources
{
    if (!shadowObject)
        return @"";

    #if !TARGET_OS_IPHONE
        NSAssert([shadowObject isKindOfClass: NSShadow.class], @"Expecting shadow attribute");

        NSShadow *shadow = shadowObject;
        CGColorRef color = [[shadow shadowColor] newCGColorWithGenericRGBColorSpace];
    #else    
        NSAssert([shadowObject isKindOfClass: RKShadow.class], @"Expecting shadow attribute");
    
        RKShadow *shadow = shadowObject;
        CGColorRef color = [shadow shadowColor];
    #endif
    
    NSUInteger colorIndex = [resources indexOfColor: color];
    
    return [NSString stringWithFormat:@"\\shad\\shadx%lu\\shady%lu\\shadr%lu\\shadc%lu ",
                   (NSUInteger)RKPointsToTwips([shadow shadowOffset].width),
                   (NSUInteger)RKPointsToTwips([shadow shadowOffset].height),
                   (NSUInteger)RKPointsToTwips([shadow shadowBlurRadius]),
                   colorIndex
            ];   
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)shadow resources:(RKResourcePool *)resources
{
    if (!shadow)
        return @"";
    
    return @"\\shad0 ";
}

@end
