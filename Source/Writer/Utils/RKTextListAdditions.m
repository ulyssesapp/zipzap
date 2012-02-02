//
//  RKTextListAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListAdditions.h"

@implementation NSTextList (RKTextListAdditions)

NSDictionary *markerIdMapping;

+ (void)load
{
    markerIdMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{box}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{check}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{circle}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{diamond}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{disc}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{hyphen}",
                       [NSNumber numberWithInt:RKTextListMarkerBullet],             @"{square}",
                       [NSNumber numberWithInt:RKTextListMarkerDecimal],            @"{lower-hexadecimal}",
                       [NSNumber numberWithInt:RKTextListMarkerDecimal],            @"{upper-hexadecimal}",
                       [NSNumber numberWithInt:RKTextListMarkerDecimal],            @"{octal}",
                       [NSNumber numberWithInt:RKTextListMarkerDecimal],            @"{decimal}",
                       [NSNumber numberWithInt:RKTextListMarkerLowerCaseLetter],    @"{lower-alpha}",
                       [NSNumber numberWithInt:RKTextListMarkerLowerCaseLetter],    @"{lower-letter}",
                       [NSNumber numberWithInt:RKTextListMarkerUpperCaseLetter],    @"{upper-alpha}",
                       [NSNumber numberWithInt:RKTextListMarkerUpperCaseLetter],    @"{upper-letter}",
                       [NSNumber numberWithInt:RKTextListMarkerLowerCaseRoman],     @"{lower-roman}",
                       [NSNumber numberWithInt:RKTextListMarkerUpperCaseRoman],     @"{upper-roman}",
                       nil];
}

- (RKTextListMarkerCode)RTFMarkerCode
{
    NSString *markerFormat = [self markerFormat];
    RKTextListMarkerCode __block markerCode = RKTextListMarkerBullet;
    
    // While the text system allows multiple markers, it encodes the RTF marker code from the first marker it finds
    [markerIdMapping enumerateKeysAndObjectsUsingBlock:^(NSString *formatSymbol, NSNumber *scannedCode, BOOL *stop) {
        if ([markerFormat rangeOfString:formatSymbol].location != NSNotFound) {
            *stop = true;
            markerCode = [scannedCode intValue];
        }
    }];
    
     return markerCode;
}

@end
