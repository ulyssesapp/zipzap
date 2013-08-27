//
//  RKBodyWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"
#import "RKResourcePool.h"
#import "RKSectionWriter.h"
#import "RKBodyWriter.h"

@implementation RKBodyWriter

+ (NSString *)RTFBodyFromDocument:(RKDocument *)document withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources
{
    NSMutableString *body = [NSMutableString new];
    
    [document.sections enumerateObjectsUsingBlock:^(id section, NSUInteger index, BOOL *stop) {
		RKSectionFirstPagePosition firstPagePosition;
		
		if (index == 0) {
			// Do not make a page break on the first section
			firstPagePosition = RKSectionStartsOnSamePage;
		}
		else {
			switch (document.pageBinding) {
				// No binding: new sections just on the next page
				case RKPageBindingNone:
					firstPagePosition = RKSectionStartsOnNextPage;
					break;
		
				case RKPageBindingRight:
				case RKPageBindingLeft:
					firstPagePosition = RKSectionStartsOnOddPage;
					break;
			}
		}
		
        [body appendString: [RKSectionWriter RTFFromSection:section withConversionPolicy:conversionPolicy firstPagePosition:firstPagePosition resources:resources]];
        
        // Place a section separator only if we have more than one section
        if (index < document.sections.count - 1) {
            [body appendString: @"\n\\sect\\sectd"];
        }
    }];
    
    return body;
}

@end
