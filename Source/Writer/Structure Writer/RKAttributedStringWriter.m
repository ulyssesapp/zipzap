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

NSArray *priorityOrderings;
NSMutableDictionary *attributeHandlersOrdering;
NSMutableDictionary *attributeHandlers;

+ (void)registerWriter:(Class)attributeWriter forAttribute:(NSString*)attributeName priority:(RKAttributedStringWriterPriority)priority
{
    if (attributeHandlers == nil) {
        attributeHandlers = [NSMutableDictionary new];
        attributeHandlersOrdering = [NSMutableDictionary new];
        priorityOrderings = nil;
    }
        // Register handler for attribute
    [attributeHandlers setValue:attributeWriter forKey:attributeName];

    // Set ordering based on priority
    NSNumber *priorityKey = [NSNumber numberWithInt: priority];
    
    if ([attributeHandlersOrdering objectForKey: priorityKey] == nil) {
        [attributeHandlersOrdering setObject:[NSMutableArray new] forKey:priorityKey];
    }
    
    NSMutableArray *priorityOrdering = [attributeHandlersOrdering objectForKey: priorityKey];
    
    [priorityOrdering addObject: attributeName];
    
    priorityOrderings = [[attributeHandlersOrdering allKeys] sortedArrayUsingSelector:@selector(compare:) ];
    
    // Validate type conformance
    //NSAssert([attributeWriter isSubclassOfClass: [RKAttributeWriter class]], @"Invalid attribute writer registered");
}

+ (NSString *)RTFFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];
    NSString *baseString = [attributedString string];
    
    // Write attribute styles
    for (NSNumber *priority in priorityOrderings) {
        NSArray *priorityOrdering = [attributeHandlersOrdering objectForKey: priority];
        
        for (NSString *attributeName in priorityOrdering) {
            Class handler = [attributeHandlers objectForKey: attributeName];
            
            // We operate on a per-paragraph level
            [baseString enumerateSubstringsInRange:NSMakeRange(0, baseString.length) options:NSStringEnumerationByParagraphs usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    [attributedString enumerateAttribute:attributeName inRange:enclosingRange options:0 usingBlock:^(id attributeValue, NSRange attributeRange, BOOL *stop) {
                        [handler addTagsForAttribute:attributeName 
                                               value:attributeValue 
                                      effectiveRange:attributeRange 
                                            toString:taggedString 
                                      originalString:attributedString 
                                    attachmentPolicy:attachmentPolicy 
                                           resources:resources
                        ];
                    }];
            }];
        }
    }
    
    return [taggedString flattenedRTFString];
}

@end
