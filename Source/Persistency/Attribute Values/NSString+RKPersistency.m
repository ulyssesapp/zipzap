//
//  NSString+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+RKPersistency.h"

@implementation NSString (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSString.class]);
    
    return propertyList;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return self;
}

@end
