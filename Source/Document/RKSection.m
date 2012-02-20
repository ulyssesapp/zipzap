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
    NSMutableDictionary *headers;
    NSMutableDictionary *footers;
}

/*!
 @abstract Internally used to retrieve an object from a map related to a certain page selector
 */
- (id)objectForPage:(RKPageSelectionMask)pageMask fromDictionary:(NSDictionary *)dictionary;

/*!
 @abstract Internally used to store an object in a map related to a certain page
 */
- (void)setObject:(id)object forSinglePage:(RKPageSelectionMask)page toDictionary:(NSMutableDictionary *)dictionary;

/*!
 @abstract Internally used to store an object in a map related to a certain page selector
 */
- (void)setObject:(id)object forPages:(RKPageSelectionMask)pageMask toDictionary:(NSMutableDictionary *)dictionary;

/*!
 @abstract Returns true, if an object can be used for all page selectors
 */
- (BOOL)hasSingleObjectForAllPagesInDictionary:(NSDictionary *)map;

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
        indexOfFirstPage = RKContinuousPageNumbering;
        pageNumberingStyle = RKPageNumberingDecimal;
        
        headers = [NSMutableDictionary new];
        footers = [NSMutableDictionary new];
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
    return [self objectForPage:pageMask fromDictionary:headers];
}

- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask
{
    [self setObject:header forPages:pageMask toDictionary:headers];
}

- (BOOL)hasSingleHeaderForAllPages
{
    return [self hasSingleObjectForAllPagesInDictionary: headers];
}

- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask
{
    return [self objectForPage:pageMask fromDictionary:footers];
}

- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask
{
   [self setObject:footer forPages:pageMask toDictionary:footers];
}

- (BOOL)hasSingleFooterForAllPages
{
    return [self hasSingleObjectForAllPagesInDictionary: footers];
}

#pragma mark -

- (id)objectForPage:(RKPageSelectionMask)pageMask fromDictionary:(NSDictionary *)dictionary
{
    NSAssert(!(pageMask & (~RKPageSelectionFirst)) || !(pageMask & (~RKPageSelectionLeft)) || !(pageMask & (~RKPageSelectionRight)), 
             @"Invalid page mask used in query.");
    
    return [dictionary objectForKey: [NSNumber numberWithUnsignedInteger:pageMask]];
}

- (void)setObject:(id)object forSinglePage:(RKPageSelectionMask)page toDictionary:(NSMutableDictionary *)dictionary
{
    NSAssert(!(page & (~RKPageSelectionFirst)) || !(page & (~RKPageSelectionLeft)) || !(page & (~RKPageSelectionRight)), 
             @"Invalid page mask used in query.");   
    
    NSNumber *key = [NSNumber numberWithUnsignedInt:page];
        
    if (object) {
        [dictionary setObject:object forKey:key];
    }
    else {
        [dictionary removeObjectForKey: key];
    }
}

- (void)setObject:(id)object forPages:(RKPageSelectionMask)pageMask toDictionary:(NSMutableDictionary *)dictionary
{
    if (pageMask & RKPageSelectionFirst)
        [self setObject:object forSinglePage:RKPageSelectionFirst toDictionary:dictionary];
    
    if (pageMask & RKPageSelectionLeft)
        [self setObject:object forSinglePage:RKPageSelectionLeft toDictionary:dictionary];
    
    if (pageMask & RKPageSelectionRight)
        [self setObject:object forSinglePage:RKPageSelectionRight toDictionary:dictionary];
}

- (BOOL)hasSingleObjectForAllPagesInDictionary:(NSDictionary *)dictionary
{
    return (    (([self objectForPage:RKPageSelectionLeft fromDictionary:dictionary]) == ([self objectForPage:RKPageSelectionRight fromDictionary:dictionary]))
             && (([self objectForPage:RKPageSelectionFirst fromDictionary:dictionary]) == ([self objectForPage:RKPageSelectionRight fromDictionary:dictionary]))
           );
}

@end
