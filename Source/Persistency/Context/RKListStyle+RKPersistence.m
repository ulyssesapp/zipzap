//
//  RKListStyle+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+RKPersistence.h"

NSString *RKListStyleLevelFormatsPersistenceKey                  = @"levelFormats";
NSString *RKListStyleStartNumbersPersistenceKey                  = @"startNumbers";
NSString *RKListStyleHeadIndentOffsetsPersistenceKey             = @"headIndentOffsets";
NSString *RKListStyleFirstLineHeadIndentOffsetsPersistenceKey    = @"firstLineheadIndentOffsets";
NSString *RKListStyleTabStopLocationsPersistenceKey              = @"tabStopLocations";
NSString *RKListStyleTabStopAlignmentsPersistenceKey             = @"tabStopAlignments";

@implementation RKListStyle (RKPersistence)

- (id)initWithPropertyList:(id)propertyList
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    self = [self initWithLevelFormats:propertyList[RKListStyleLevelFormatsPersistenceKey] startNumbers:propertyList[RKListStyleStartNumbersPersistenceKey]];
    
    if (self) {
        self.headIndentOffsets = propertyList[RKListStyleHeadIndentOffsetsPersistenceKey];
        self.firstLineHeadIndentOffsets = propertyList[RKListStyleFirstLineHeadIndentOffsetsPersistenceKey];
        self.tabStopLocations = propertyList[RKListStyleTabStopLocationsPersistenceKey];
        self.tabStopAlignments = propertyList[RKListStyleTabStopAlignmentsPersistenceKey];
    }

    return self;
}

- (id)propertyListRepresentation
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    if (self.levelFormats)
        propertyList[RKListStyleLevelFormatsPersistenceKey] = self.levelFormats;
    
    if (self.startNumbers)
        propertyList[RKListStyleStartNumbersPersistenceKey] = self.startNumbers;

    if (self.firstLineHeadIndentOffsets)
        propertyList[RKListStyleFirstLineHeadIndentOffsetsPersistenceKey] = self.firstLineHeadIndentOffsets;
    
    if (self.headIndentOffsets)
        propertyList[RKListStyleHeadIndentOffsetsPersistenceKey] = self.headIndentOffsets;

    if (self.tabStopLocations)
        propertyList[RKListStyleTabStopLocationsPersistenceKey] = self.tabStopLocations;

    if (self.tabStopAlignments)
        propertyList[RKListStyleTabStopAlignmentsPersistenceKey] = self.tabStopAlignments;
    
    return propertyList;
}

@end
