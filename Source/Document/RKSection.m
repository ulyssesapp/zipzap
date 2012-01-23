//
//  RKSection.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

/*!
 @abstract Internal methods
 */
@interface RKSection ()
{
    NSMapTable *headers;
    NSMapTable *footers;
}

/*!
 @abstract Internally used to retrieve a text in a header/footer mapping for a given page type mask
 */
- (NSAttributedString *)frametextForPage:(RKPageSelectionMask)pageMask fromTextMap:(NSMapTable *)frametextMap;

/*!
 @abstract Internally used to set a text in a header/footer mapping for a given page type mask
 */
- (void)setFrametext:(NSAttributedString *)text forPages:(RKPageSelectionMask)pageMask toTextMap:(NSMapTable *)frametextMap;
@end


@implementation RKSection

@synthesize content, numberOfColumns, indexOfFirstPage, pageNumberingStyle;

+ (id)sectionWithContent:(NSAttributedString *)content
{
    return [[RKSection alloc] initWithContent:content];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        numberOfColumns = 1;
        indexOfFirstPage = 1;
        pageNumberingStyle = RKPageNumberingDecimal;
        
        headers = [NSMapTable new];
        footers = [NSMapTable new];
    }
    
    return self;
}

- (id)initWithContent:(NSAttributedString *)initialContent
{
     NSAssert(initialContent != nil, @"Initial content string must not be nil");    
    
    self = [self init];
    
    if (self) {
        content = initialContent;
    }
    
    return self;
}

- (NSAttributedString *)frametextForPage:(RKPageSelectionMask)pageMask fromTextMap:(NSMapTable *)frametextMap
{
    NSAssert(!(pageMask & (~RKPageMaskFirstPage)) || !(pageMask & (~RKPageMaskLeftPage)) || !(pageMask & (~RKPageMaskRightPage)), 
             @"Invalid page mask used in query.");
    
    return [frametextMap objectForKey:[NSNumber numberWithUnsignedInteger:pageMask]];
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
