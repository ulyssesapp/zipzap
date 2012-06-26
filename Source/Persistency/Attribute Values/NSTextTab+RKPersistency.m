//
//  NSTextTab+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSTextTab+RKPersistency.h"

NSString *NSTextTabAlignmentPersistencyKey  =   @"alignment";
NSString *NSTextTabLocationPersistencyKey   =   @"location";
NSString *NSTextTabOptionsPersistencyKey    =   @"options";

@implementation NSTextTab (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    return [[NSTextTab alloc] initWithTextAlignment:[propertyList[NSTextTabAlignmentPersistencyKey] unsignedIntegerValue] location:[propertyList[NSTextTabLocationPersistencyKey] floatValue] options:propertyList[NSTextTabOptionsPersistencyKey]];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    propertyList[NSTextTabAlignmentPersistencyKey] = @(self.alignment);
    propertyList[NSTextTabLocationPersistencyKey] = @(self.location);
    
    if (self.options)
        propertyList[NSTextTabOptionsPersistencyKey] = self.options;

    return propertyList;
}

@end
