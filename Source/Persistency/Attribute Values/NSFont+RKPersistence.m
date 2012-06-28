//
//  NSFont+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSFont+RKPersistence.h"

NSString *NSFontNamePersistenceKey = @"name";
NSString *NSFontSizePersistenceKey = @"size";

@implementation NSFont (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSString *name = propertyList[NSFontNamePersistenceKey];
    CGFloat size = [propertyList[NSFontSizePersistenceKey] floatValue];

    return [NSFont fontWithName:name size:size];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    return @{
        NSFontNamePersistenceKey:       self.fontName,
        NSFontSizePersistenceKey:       @(self.pointSize),
    };
}

@end
