//
//  RKSection.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"
#import "RKSectionInternal.h"

@implementation RKSection
{
    NSMapTable* headers;
    NSMapTable* footers;
}

@synthesize content, numberOfColumns, numberOfFirstPage, pageNumberingStyle, headers, footers;

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
        
        headers = [NSMapTable new];
        footers = [NSMapTable new];
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

- (NSAttributedString *)frametextForPage:(RKPageSelectionMask)pageMask fromTextMap:(NSMapTable *)frametextMap
{ 
    if ((pageMask == RKPageMaskFirstPage) || (pageMask == RKPageMaskAllPages))
        return [frametextMap objectForKey:[NSNumber numberWithUnsignedInteger:RKPageMaskFirstPage]];
    
    if (pageMask == RKPageMaskLeftPage)
        return [frametextMap objectForKey:[NSNumber numberWithUnsignedInteger:RKPageMaskLeftPage]];
    
    if (pageMask == RKPageMaskRightPage)
        return [frametextMap objectForKey:[NSNumber numberWithUnsignedInteger:RKPageMaskRightPage]];
    
    return nil; 
}

- (void)setFrametext:(NSAttributedString *)text forPages:(RKPageSelectionMask)pageMask toTextMap:(NSMapTable *)frametextMap
{
    if (pageMask & RKPageMaskFirstPage)
        [frametextMap setObject:text forKey:[NSNumber numberWithUnsignedInteger:RKPageMaskFirstPage]];
    
    if (pageMask & RKPageMaskLeftPage)
        [frametextMap setObject:text forKey:[NSNumber numberWithUnsignedInteger:RKPageMaskLeftPage]];
    
    if (pageMask & RKPageMaskRightPage)
        [frametextMap setObject:text forKey:[NSNumber numberWithUnsignedInteger:RKPageMaskRightPage]];
}

- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask
{
    return [self frametextForPage:pageMask fromTextMap:headers];
}

- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask
{
    [self setFrametext:header forPages:pageMask toTextMap:headers];
}

- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask
{
    return [self frametextForPage:pageMask fromTextMap:footers];
}

- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask
{
   [self setFrametext:footer forPages:pageMask toTextMap:footers];
}

@end
