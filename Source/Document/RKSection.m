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

+(id)sectionWithContent:(NSAttributedString *)content
{
    RKSection *section = [[RKSection alloc] initWithContent:content];

    return section;
}

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

-(id)initWithContent:(NSAttributedString *)initialContent
{
    self = [self init];
    
    if (self) {
        content = initialContent;
    }
    
    return self;
}

- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask
{
    if ((pageMask == RKPageMaskFirstPage) || (pageMask == RKPageMaskAllPages))
        return headers[RKFirstPage];
    
    if (pageMask == RKPageMaskLeftPage)
        return headers[RKLeftPage];
    
    if (pageMask == RKPageMaskRightPage)
        return headers[RKRightPage];
    
    return nil;
}

- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask
{
    sameHeaderForAllPages = (pageMask == RKPageMaskAllPages);
    
    if (pageMask & RKPageMaskFirstPage)
        headers[RKFirstPage] = header;

    if (pageMask & RKPageMaskLeftPage)
        headers[RKLeftPage] = header;

    if (pageMask & RKPageMaskRightPage)
        headers[RKRightPage] = header;
}

- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask
{
    if (pageMask == RKPageMaskFirstPage)
        return footers[RKFirstPage];
    
    if (pageMask == RKPageMaskLeftPage)
        return footers[RKLeftPage];
    
    if (pageMask == RKPageMaskRightPage)
        return footers[RKRightPage];
    
    return nil;   
}

- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask
{
    sameFooterForAllPages = (pageMask == RKPageMaskAllPages);
    
    if ((pageMask == RKPageMaskFirstPage) || (pageMask == RKPageMaskAllPages))
        footers[RKFirstPage] = footer;
    
    if (pageMask & RKPageMaskLeftPage)
        footers[RKLeftPage] = footer;
    
    if (pageMask & RKPageMaskRightPage)
        footers[RKRightPage] = footer;
}

@end
