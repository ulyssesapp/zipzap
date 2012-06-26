//
//  NSFont+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSFont+RKPersistency.h"

NSString *NSFontNamePersistencyKey = @"name";
NSString *NSFontSizePersistencyKey = @"size";

@implementation NSFont (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSString *name = propertyList[NSFontNamePersistencyKey];
    CGFloat size = [propertyList[NSFontSizePersistencyKey] floatValue];

    return [NSFont fontWithName:name size:size];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return @{
        NSFontNamePersistencyKey:       self.fontName,
        NSFontSizePersistencyKey:       @(self.pointSize),
    };
}

@end
