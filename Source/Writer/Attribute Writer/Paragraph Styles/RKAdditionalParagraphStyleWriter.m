//
//  RKAdditionalParagraphStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyleWriter.h"

#import "RKAdditionalParagraphStyle.h"
#import "RKAttributedStringWriter.h"
#import "RKTaggedString.h"

@implementation RKAdditionalParagraphStyleWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKAdditionalParagraphStyleAttributeName priority:RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel];
    }
}

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName
                                  value:(RKAdditionalParagraphStyle *)value
                           styleSetting:(NSDictionary *)styleSetting
                              resources:(RKResourcePool *)resources
{
	NSMutableString *tags = [NSMutableString new];
	
    if (value.keepWithFollowingParagraph)
        [tags appendString: @"\\keepn "];

	if (value.hyphenationEnabled)
		[tags appendString: @"\\hyphpar1 "];
	else if (resources.document.hyphenationEnabled)
		[tags appendString: @"\\hyphpar0 "];
	
	if (value.overrideLineHeightAndSpacing) {
		CGFloat distance = (value.baselineDistance <= 0) ? 1 : value.baselineDistance;
		
		// \sl must be a positive value, to ensure that the line as at least the height of the tallest character.
		[tags appendFormat: @"\\sl%li\\slmult0", (NSInteger)RKPointsToTwips(distance)];
	}
	
	return tags;
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(RKAdditionalParagraphStyle *)value
             effectiveRange:(NSRange)range
                   toString:(RKTaggedString *)taggedString
             originalString:(NSAttributedString *)originalString
           conversionPolicy:(RKConversionPolicy)conversionPolicy
                  resources:(RKResourcePool *)resources;
{
    [taggedString registerTag:[self stylesheetTagForAttribute:attributeName value:value styleSetting:nil resources:resources] forPosition:range.location];
}

@end
