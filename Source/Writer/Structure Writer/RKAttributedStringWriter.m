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

@implementation RKAttributedStringWriter

/*!
 @abstract An array of dictionaries describing the handlers registered to the attributed string writer.
 @description The array is sorted by the priority of the handlers.
 
  Each dictionary contains the following fields:
    'attributeName'     The name of the attribute (e.g. NSParagraphStyleAttributeName)
    'priority'          The priority of the handler (one of RKAttributedStringWriterPriority)
    'writerClass'       The handling class
 */
NSMutableArray *RKAttributedStringWriterHandlers;

+ (void)registerWriter:(Class)attributeWriter forAttribute:(NSString*)attributeName priority:(RKAttributedStringWriterPriority)priority
{
    if (!RKAttributedStringWriterHandlers) {
        RKAttributedStringWriterHandlers = [NSMutableArray new];
    }
    
    // Register handler
    [RKAttributedStringWriterHandlers addObject:
     @{@"attributeName": attributeName,
        @"priority": [NSNumber numberWithInt:priority],
        @"writerClass": attributeWriter}
    ];
    
    // Order handlers by priority
    // Additionally order them by attribute name to improve testability
    [RKAttributedStringWriterHandlers sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES], 
                                                                                      [NSSortDescriptor sortDescriptorWithKey:@"writerClass.description" ascending:YES],
                                                                                      [NSSortDescriptor sortDescriptorWithKey:@"attributeName" ascending:YES]]];
    
    // Validate type conformance
    NSAssert([attributeWriter isSubclassOfClass: [RKAttributeWriter class]], @"Invalid attribute writer registered");
}

+ (NSAttributedString *)attributedStringByAdjustingStyles:(NSAttributedString *)attributedString usingPreprocessingPolicy:(RKAttributePreprocessingPolicy)preprocessingPolicy
{
    NSString *baseString = attributedString.string;
    
    // Pre-process any styles
    NSMutableAttributedString *preprocessedString = [attributedString mutableCopy];
    
    for (NSDictionary *handlerDescription in RKAttributedStringWriterHandlers) {
        NSString *attributeName = handlerDescription[@"attributeName"];
        Class handler = handlerDescription[@"writerClass"];
        
        // We operate on a per-paragraph level
        [preprocessedString enumerateAttribute:attributeName inRange:NSMakeRange(0, baseString.length) options:0 usingBlock:^(id attributeValue, NSRange attributeRange, BOOL *stop) {
            [handler preprocessAttribute:attributeName
                                   value:attributeValue
                          effectiveRange:attributeRange
                      ofAttributedString:preprocessedString
							 usingPolicy:preprocessingPolicy
             ];
        }];
    }
    
    return preprocessedString;
}

+ (NSString *)RTFFromAttributedString:(NSAttributedString *)attributedString withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
	// Setup adjustment policy from conversion policy
	RKAttributePreprocessingPolicy adjustmentPolicy = (conversionPolicy & RKConversionPolicyPositionListMarkerUsingIndent) ? RKAttributePreprocessorListMarkerPositionsUsingIndent : 0;
	adjustmentPolicy |= (conversionPolicy & RKConversionPolicyInnerListParagraphsUsingLineBreak) ? RKAttributePreprocessorInnerListParagraphsUsingLineBreak : 0;
	
	// Preprocess string
    NSAttributedString *preprocessedString = [self attributedStringByAdjustingStyles:attributedString usingPreprocessingPolicy:adjustmentPolicy];
    
    NSString *baseString = preprocessedString.string;
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString: baseString];
    
    // Write attribute styles
    for (NSDictionary *handlerDescription in RKAttributedStringWriterHandlers) {
        NSString *attributeName = handlerDescription[@"attributeName"];
        Class handler = handlerDescription[@"writerClass"];
        NSUInteger priority = [handlerDescription[@"priority"] unsignedIntegerValue];
            
        // We operate on a per-paragraph level
        [baseString enumerateSubstringsInRange:NSMakeRange(0, baseString.length) options:NSStringEnumerationByParagraphs usingBlock:
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             __block NSUInteger attributeCountPerParagraph = 0;
             
             [preprocessedString enumerateAttribute:attributeName inRange:enclosingRange options:0 usingBlock:^(id attributeValue, NSRange attributeRange, BOOL *stop) {
                    if (attributeValue)
                        attributeCountPerParagraph ++;
                 
                    // Ensure that we only apply one paragraph style of a certain type per paragraph
                    if ((attributeCountPerParagraph > 1) && ((priority == RKAttributedStringWriterPriorityParagraphLevel) || (priority == RKAttributedStringWriterPriorityParagraphStyleSheetLevel)))
                        return;

                    // Translate style
                    [handler addTagsForAttribute:attributeName 
                                           value:attributeValue 
                                  effectiveRange:attributeRange 
                                        toString:taggedString 
                                  originalString:preprocessedString 
                                conversionPolicy:conversionPolicy 
                                       resources:resources
                    ];
                }];
        }];
    }
    
    return [taggedString flattenedRTFString];
}

+ (NSString *)stylesheetTagsFromAttributes:(NSDictionary *)attributes resources:(RKResourcePool *)resources
{
    NSMutableString *stylesheetTags = [NSMutableString new];
    
    // Write attribute styles
    for (NSDictionary *handlerDescription in RKAttributedStringWriterHandlers) {
        NSString *attributeName = handlerDescription[@"attributeName"];
        Class handler = handlerDescription[@"writerClass"];

        id attributeValue = [attributes valueForKey:attributeName];
        
        [stylesheetTags appendString:
         [handler stylesheetTagForAttribute:attributeName value:attributeValue styleSetting:attributes resources:resources]
         ];
    }

    return stylesheetTags;
}

@end
