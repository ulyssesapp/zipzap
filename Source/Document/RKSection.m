//
//  RKSection.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

// Possible types of headers and footers
typedef enum {
    RKFirstPage = 0,
    RKLeftPage = 1,
    RKRightPage = 2,
    
    RKHighestPage = 3
}RKPageSelection;

@implementation RKSection
{
    NSAttributedString* headers[RKHighestPage];
    NSAttributedString* footers[RKHighestPage];
}

@synthesize content, numberOfColumns, numberOfFirstPage, pageNumberingStyle, sameHeaderForAllPages, sameFooterForAllPages;

-(id)init
{
    self = [super init];
    
    if (self) {
        numberOfColumns = 1;
        numberOfFirstPage = 1;
        pageNumberingStyle = RKPageNumberingDecimal;
        
        sameHeaderForAllPages = true;
        sameFooterForAllPages = true;
    }
    
    return self;
}

@end
