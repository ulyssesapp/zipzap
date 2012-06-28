//
//  RKListStyle+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+RKPersistence.h"

NSString *RKListStyleLevelFormatsPersistenceKey         = @"levelFormats";
NSString *RKListStyleStartNumbersPersistenceKey         = @"startNumbers";

@implementation RKListStyle (RKPersistence)

- (id)initWithPropertyList:(id)propertyList
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    return [self initWithLevelFormats:propertyList[RKListStyleLevelFormatsPersistenceKey] startNumbers:propertyList[RKListStyleStartNumbersPersistenceKey]];
}

- (id)propertyListRepresentation
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    if (self.levelFormats)
        propertyList[RKListStyleLevelFormatsPersistenceKey] = self.levelFormats;
    
    if (self.startNumbers)
        propertyList[RKListStyleStartNumbersPersistenceKey] = self.startNumbers;
    
    return propertyList;
}

@end
