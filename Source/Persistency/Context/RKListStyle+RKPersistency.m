//
//  RKListStyle+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+RKPersistency.h"

NSString *RKListStyleLevelFormatsPersistencyKey         = @"levelFormats";
NSString *RKListStyleStartNumbersPersistencyKey         = @"startNumbers";

@implementation RKListStyle (RKPersistency)

- (id)initWithPropertyList:(id)propertyList
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    return [self initWithLevelFormats:propertyList[RKListStyleLevelFormatsPersistencyKey] startNumbers:propertyList[RKListStyleStartNumbersPersistencyKey]];
}

- (id)propertyListRepresentation
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    if (self.levelFormats)
        propertyList[RKListStyleLevelFormatsPersistencyKey] = self.levelFormats;
    
    if (self.startNumbers)
        propertyList[RKListStyleStartNumbersPersistencyKey] = self.startNumbers;
    
    return propertyList;
}

@end
