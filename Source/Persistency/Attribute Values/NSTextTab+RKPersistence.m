//
//  NSTextTab+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSTextTab+RKPersistence.h"

NSString *NSTextTabAlignmentPersistenceKey  =   @"alignment";
NSString *NSTextTabLocationPersistenceKey   =   @"location";
NSString *NSTextTabOptionsPersistenceKey    =   @"options";

@implementation NSTextTab (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    return [[NSTextTab alloc] initWithTextAlignment:[propertyList[NSTextTabAlignmentPersistenceKey] unsignedIntegerValue] location:[propertyList[NSTextTabLocationPersistenceKey] floatValue] options:propertyList[NSTextTabOptionsPersistenceKey]];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    propertyList[NSTextTabAlignmentPersistenceKey] = @(self.alignment);
    propertyList[NSTextTabLocationPersistenceKey] = @(self.location);
    
    if (self.options)
        propertyList[NSTextTabOptionsPersistenceKey] = self.options;

    return propertyList;
}

@end
