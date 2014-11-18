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
    NSMutableDictionary *_headers;
    NSMutableDictionary *_footers;
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

/*!
 @abstract Enumerates all objects according to their page selectors
 */
- (void)enumerateObjectsInPageSetting:(NSMutableDictionary *)dictionary usingBlock:(void(^)(RKPageSelectionMask pageSelector, id object))block;

@end


@implementation RKSection

- (id)init
{
    self = [super init];
    
    if (self) {
        _numberOfColumns = 1;
        _indexOfFirstPage = RKContinuousPageNumbering;
        _pageNumberingStyle = RKPageNumberingDecimal;
        
        _headers = [NSMutableDictionary new];
        _footers = [NSMutableDictionary new];
        _columnSpacing = 36;
    }
    
    return self;
}

- (id)initWithContent:(NSAttributedString *)initialContent
{
	NSAssert(initialContent != nil, @"Initial content string must not be nil");
	
	self = [self init];
	
	if (self) {
		_content = initialContent;
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RKSection *copy = [[RKSection allocWithZone: zone] initWithContent: self.content.copy];
    
    if (self.hasSingleHeaderForAllPages) {
        [copy setHeader:[[self headerForPage:RKPageSelectionFirst] copy] forPages:RKPageSelectorAll];
    }
    else {
        [copy setHeader:[[self headerForPage:RKPageSelectionFirst] copy] forPages:RKPageSelectionFirst];
        [copy setHeader:[[self headerForPage:RKPageSelectionLeft] copy] forPages:RKPageSelectionLeft];
        [copy setHeader:[[self headerForPage:RKPageSelectionRight] copy] forPages:RKPageSelectionRight];        
    }

    if (self.hasSingleFooterForAllPages) {
        [copy setFooter:[[self footerForPage:RKPageSelectionFirst] copy] forPages:RKPageSelectorAll];
    }
    else {
        [copy setFooter:[[self footerForPage:RKPageSelectionFirst] copy] forPages:RKPageSelectionFirst];
        [copy setFooter:[[self footerForPage:RKPageSelectionLeft] copy] forPages:RKPageSelectionLeft];
        [copy setFooter:[[self footerForPage:RKPageSelectionRight] copy] forPages:RKPageSelectionRight];        
    }
    
    copy.numberOfColumns = self.numberOfColumns;
    copy.indexOfFirstPage = self.indexOfFirstPage;
    copy.pageNumberingStyle = self.pageNumberingStyle;
    copy.columnSpacing = self.columnSpacing;
    
    return copy;
}

- (BOOL)isEqual:(RKSection *)object
{
    if (![object isKindOfClass: RKSection.class])
        return NO;
    
    // Compare headers
    __block BOOL headersEqual = YES;
    
    [self enumerateHeadersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *header) {
        headersEqual &= [header isEqual: [object headerForPage: (pageSelector == RKPageSelectorAll) ? RKPageSelectionFirst : pageSelector]];
    }];
    
    if (!headersEqual)
        return NO;

    // Compare footer
    __block BOOL footersEqual = YES;
    
    [self enumerateFootersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *footer) {
        footersEqual &= [footer isEqual: [object footerForPage: (pageSelector == RKPageSelectorAll) ? RKPageSelectionFirst : pageSelector]];
    }];
    
    if (!footersEqual)
        return NO;
    
    // Compare others
    return  [self.content isEqual: object.content]
        &&  (self.numberOfColumns == object.numberOfColumns)
        &&  (self.indexOfFirstPage == object.indexOfFirstPage)
        &&  (self.pageNumberingStyle == object.pageNumberingStyle)
        &&  (self.columnSpacing == object.columnSpacing)
    ;
}

- (NSUInteger)hash
{
	return 1;
}


#pragma mark - Header and Footer

- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask
{
    return [self objectForPage:pageMask fromDictionary:_headers];
}

- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask
{
    [self setObject:header forPages:pageMask toDictionary:_headers];
}

- (BOOL)hasSingleHeaderForAllPages
{
    return [self hasSingleObjectForAllPagesInDictionary: _headers];
}

- (void)enumerateHeadersUsingBlock:(void (^)(RKPageSelectionMask, NSAttributedString *))block
{
    [self enumerateObjectsInPageSetting:_headers usingBlock:block];
}

- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask
{
    return [self objectForPage:pageMask fromDictionary:_footers];
}

- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask
{
   [self setObject:footer forPages:pageMask toDictionary:_footers];
}

- (BOOL)hasSingleFooterForAllPages
{
    return [self hasSingleObjectForAllPagesInDictionary: _footers];
}

- (void)enumerateFootersUsingBlock:(void (^)(RKPageSelectionMask, NSAttributedString *))block
{
    [self enumerateObjectsInPageSetting:_footers usingBlock:block];
}


#pragma mark -

- (id)objectForPage:(RKPageSelectionMask)pageMask fromDictionary:(NSDictionary *)dictionary
{
    NSAssert((pageMask & (RKPageSelectionLeft | RKPageSelectionRight)) != (RKPageSelectionLeft | RKPageSelectionRight),
             @"Invalid page mask used in query.");
    
	// Use first page if given. Fall back to left / right otherwise.
	if (pageMask & RKPageSelectionFirst) {
		id object = dictionary[@(RKPageSelectionFirst)];
		if (object)
			return object;
	}
	
    return dictionary[@(pageMask & (~RKPageSelectionFirst))];
}

- (void)setObject:(id)object forSinglePage:(RKPageSelectionMask)page toDictionary:(NSMutableDictionary *)dictionary
{
    NSAssert(!(page & (~RKPageSelectionFirst)) || !(page & (~RKPageSelectionLeft)) || !(page & (~RKPageSelectionRight)), 
             @"Invalid page mask used in query.");   
    
    NSNumber *key = [NSNumber numberWithUnsignedInt:page];
        
    if (object) {
        dictionary[key] = object;
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

- (void)enumerateObjectsInPageSetting:(NSMutableDictionary *)dictionary usingBlock:(void(^)(RKPageSelectionMask pageSelector, id object))block
{
    if (!dictionary.count)
        return;
    
    if ([self hasSingleObjectForAllPagesInDictionary:dictionary]) {
        block(RKPageSelectorAll, [self objectForPage:RKPageSelectionFirst fromDictionary:dictionary]);
        return;
    }
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *selector, id object, BOOL *stop) {
        if (object)
            block(selector.unsignedIntegerValue, object);
    }];
}

@end
