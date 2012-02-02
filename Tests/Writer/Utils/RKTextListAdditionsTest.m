//
//  RKTextListAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListAdditionsTest.h"
#import "RKTextListAdditions.h"

@implementation RKTextListAdditionsTest

- (void)testEncodingKnownMarkers
{
    NSTextList *textList = [[NSTextList alloc] initWithMarkerFormat:@"----{decimal}----" options:0 ];
    
    STAssertEquals([textList RTFMarkerCode], RKTextListMarkerDecimal, @"Invalid marker translation");
}

- (void)testEncodingUnknownMarkers
{
    NSTextList *textList = [[NSTextList alloc] initWithMarkerFormat:@"---- ?? ----" options:0 ];
    
    STAssertEquals([textList RTFMarkerCode], RKTextListMarkerBullet, @"Unknown marker translation");
}


@end
