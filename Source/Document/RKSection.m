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
 @abstract Internally used to retrieve an object from a map related to a certain page selector
 */
- (id)objectForPage:(RKPageSelectionMask)pageMask fromMap:(NSMapTable *)map;

/*!
 @abstract Internally used to store an object in a map relate to a certain page selector
 */
- (void)setObject:(id)object forPages:(RKPageSelectionMask)pageMask toMap:(NSMapTable *)map;

/*!
 @abstract Returns true, if an object can be used for all page selectors
 */
- (BOOL)hasSingleObjectForAllPagesInMap:(NSMapTable *)map;

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
        
        headers = [NSMapTable mapTableWithStrongToStrongObjects];
        footers = [NSMapTable mapTableWithStrongToStrongObjects];
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

#pragma mark - Header and Footer

- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask
{
    return [self objectForPage:pageMask fromMap:headers];
}

- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask
{
    [self setObject:header forPages:pageMask toMap:headers];
}

- (BOOL)hasSingleHeaderForAllPages
{
    return [self hasSingleObjectForAllPagesInMap: headers];
}

- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask
{
    return [self objectForPage:pageMask fromMap:footers];
}

- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask
{
   [self setObject:footer forPages:pageMask toMap:footers];
}

- (BOOL)hasSingleFooterForAllPages
{
    return [self hasSingleObjectForAllPagesInMap: footers];
}

#pragma mark -

- (id)objectForPage:(RKPageSelectionMask)pageMask fromMap:(NSMapTable *)map
{
    NSAssert(!(pageMask & (~RKPageSelectionFirst)) || !(pageMask & (~RKPageSelectionLeft)) || !(pageMask & (~RKPageSelectionRight)), 
             @"Invalid page mask used in query.");
    
    return [map objectForKey: [NSNumber numberWithUnsignedInteger:pageMask]];
}

- (void)setObject:(id)object forPages:(RKPageSelectionMask)pageMask toMap:(NSMapTable *)map
{
    if (pageMask & RKPageSelectionFirst)
        [map setObject:object forKey: [NSNumber numberWithUnsignedInteger:RKPageSelectionFirst]];
    
    if (pageMask & RKPageSelectionLeft)
        [map setObject:object forKey: [NSNumber numberWithUnsignedInteger:RKPageSelectionLeft]];
    
    if (pageMask & RKPageSelectionRight)
        [map setObject:object forKey: [NSNumber numberWithUnsignedInteger:RKPageSelectionRight]];
}

- (BOOL)hasSingleObjectForAllPagesInMap:(NSMapTable *)map
{
    return (    (([self objectForPage:RKPageSelectionLeft fromMap:map]) == ([self objectForPage:RKPageSelectionRight fromMap:map]))
             && (([self objectForPage:RKPageSelectionFirst fromMap:map]) == ([self objectForPage:RKPageSelectionRight fromMap:map]))
           );
}

@end
