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
    [RKAttributedStringWriter registerHandler:self forAttribute:NSShadowAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSShadow *)shadow
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (shadow == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:[shadow shadowColor]];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\shad\\shadx%u\\shady%u\\shadr%u\\shadc%u ",
                               (NSUInteger)RKPointsToTwips([shadow shadowOffset].width),
                               (NSUInteger)RKPointsToTwips([shadow shadowOffset].height),
                               (NSUInteger)RKPointsToTwips([shadow shadowBlurRadius]),
                               colorIndex
                               ]
                  forPosition:range.location];
    
    [taggedString registerClosingTag:@"\\shad0 " forPosition:(NSMaxRange(range))];
}

@end
