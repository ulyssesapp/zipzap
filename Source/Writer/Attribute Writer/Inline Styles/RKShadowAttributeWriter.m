//
//  RKShadowAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKShadowAttributeWriter.h"

@implementation RKShadowAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSShadowAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSShadow *)shadow resources:(RKResourcePool *)resources
{
    if (!shadow)
        return @"";
    
    NSUInteger colorIndex = [resources indexOfColor:[shadow shadowColor]];
    
    return [NSString stringWithFormat:@"\\shad\\shadx%u\\shady%u\\shadr%u\\shadc%u ",
                   (NSUInteger)RKPointsToTwips([shadow shadowOffset].width),
                   (NSUInteger)RKPointsToTwips([shadow shadowOffset].height),
                   (NSUInteger)RKPointsToTwips([shadow shadowBlurRadius]),
                   colorIndex
            ];   
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSShadow *)shadow resources:(RKResourcePool *)resources
{
    if (!shadow)
        return @"";
    
    return @"\\shad0 ";
}

@end
