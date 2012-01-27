//
//  RKFontStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFontStyleWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"

@interface RKFontStyleWriter ()

/*!
 @abstract Generates the required tags for charracter styles
 */
+ (void)tagCharracterStyleAttributes:(NSDictionary *)attributeName;

/*!
 @abstract Generates the required tags for a font style
 */
+ (NSString *)RTFfromFont:(NSFont *)paragraphStyle resources:(RKResourcePool *)resources;

/*!
 @abstract Extracts all charracter styles of a font
 */
+ (NSDictionary *)CharracterStylesfromFont:(NSFont *)font;

@end

@implementation RKFontStyleWriter

+ (void)tag:(RKTaggedString *)taggedString withFontStylesOfAttributedString:(NSAttributedString *)attributedString resources:(RKResourcePool *)resources
{
    
}

@end
