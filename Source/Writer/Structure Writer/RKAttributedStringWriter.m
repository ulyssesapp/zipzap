//
//  RKAttributedStringWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKAttributedStringWriter.h"

#import "RKParagraphStyleWriter.h"

@interface RKAttributedStringWriter ()

@end

@implementation RKAttributedStringWriter

NSMutableArray *attributeHandlersOrdering;
NSMutableDictionary *attributeHandlers;

+ (void)registerHandler:(Class)attributeWriter forAttribute:(NSString*)attributeName withPriorization:(BOOL)hasPriority
{
    if (attributeHandlers == nil) {
        attributeHandlers = [NSMutableDictionary new];
        attributeHandlersOrdering = [NSMutableArray new];
    }
    
    [attributeHandlers setValue:attributeWriter forKey:attributeName];
    
    if (hasPriority) {
        [attributeHandlersOrdering insertObject:attributeName atIndex:0];
    }
    else {
        [attributeHandlersOrdering addObject:attributeName];
    }
    
    //NSAssert([attributeWriter isSubclassOfClass: [RKAttributeWriter class]], @"Invalid attribute writer registered");
}

+ (void)registerHandler:(Class)attributeWriter forAttribute:(NSString*)attributeName
{
    [self registerHandler:attributeWriter forAttribute:attributeName withPriorization:false];
}

+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];
    
    // Write attribute styles
    for (NSString *attributeName in attributeHandlersOrdering) {
        Class handler = [attributeHandlers objectForKey: attributeName];
        
        [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(Class value, NSRange range, BOOL *stop) {
            [handler addTagsForAttribute:value toTaggedString:taggedString inRange:range withAttachmentPolicy:attachmentPolicy resources:resources];
        }];
        
    }
    
    return [taggedString flattenedRTFString];
}

@end
