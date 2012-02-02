//
//  RKTextListConversionAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListConversionAdditions.h"
#import "RKTextListConversionAdditionsTest.h"

@implementation RKTextListConversionAdditionsTest

-(void)testConvertRTFFormatCode
{
    RKTextList *decimal = [RKTextList textListWithGeneralLevelFormat:@"--- %d ---"];
    RKTextList *lowerRoman = [RKTextList textListWithGeneralLevelFormat:@"--- %r ---"];
    RKTextList *upperRoman = [RKTextList textListWithGeneralLevelFormat:@"--- %R ---"];
    RKTextList *lowerAlpha = [RKTextList textListWithGeneralLevelFormat:@"--- %a ---"];
    RKTextList *upperAlpha = [RKTextList textListWithGeneralLevelFormat:@"--- %A ---"];
    RKTextList *bullet = [RKTextList textListWithGeneralLevelFormat:@"--- * ---"];
    
    STAssertEquals([decimal RTFFormatCodeOfLevel:100], RKTextListFormatCodeDecimal, @"Invalid format code");
    STAssertEquals([lowerRoman RTFFormatCodeOfLevel:100], RKTextListFormatCodeLowerCaseRoman, @"Invalid format code");
    STAssertEquals([upperRoman RTFFormatCodeOfLevel:100], RKTextListFormatCodeUpperCaseRoman, @"Invalid format code");
    STAssertEquals([lowerAlpha RTFFormatCodeOfLevel:100], RKTextListFormatCodeLowerCaseLetter, @"Invalid format code");
    STAssertEquals([upperAlpha RTFFormatCodeOfLevel:100], RKTextListFormatCodeUpperCaseLetter, @"Invalid format code");
    STAssertEquals([bullet RTFFormatCodeOfLevel:100], RKTextListFormatCodeBullet, @"Invalid format code");
}

@end
