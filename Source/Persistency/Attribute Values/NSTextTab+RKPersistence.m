//
//  NSTextTab+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSTextTab+RKPersistence.h"

#import "NSDictionary+FlagSerialization.h"

NSString *NSTextTabAlignmentPersistenceKey  =   @"alignment";
NSString *NSTextTabLocationPersistenceKey   =   @"location";
NSString *NSTextTabOptionsPersistenceKey    =   @"options";

NSDictionary *NSTextTabAlignmentEnumDescription;

@implementation NSTextTab (RKPersistence)

+ (void)load
{
    NSTextTabAlignmentEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithUnsignedInteger: NSLeftTabStopType],        @"left",
                                         [NSNumber numberWithUnsignedInteger: NSRightTabStopType],       @"right",
                                         [NSNumber numberWithUnsignedInteger: NSCenterTabStopType],      @"center",
                                         [NSNumber numberWithUnsignedInteger: NSDecimalTabStopType],     @"decimal",
                                        nil];
}

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSUInteger tabAlignment = [NSTextTabAlignmentEnumDescription unsignedEnumValueFromString:[propertyList objectForKey: NSTextTabAlignmentPersistenceKey] error:error];
    
    return [[NSTextTab alloc] initWithTextAlignment:tabAlignment location:[[propertyList objectForKey: NSTextTabLocationPersistenceKey] floatValue] options:[propertyList objectForKey: NSTextTabOptionsPersistenceKey]];
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    [propertyList setObject:[NSTextTabAlignmentEnumDescription stringFromUnsignedEnumValue: self.alignment] forKey: NSTextTabAlignmentPersistenceKey];
    [propertyList setObject:[NSNumber numberWithFloat: self.location] forKey: NSTextTabLocationPersistenceKey];
    
    if (self.options)
        [propertyList setObject:self.options forKey:NSTextTabOptionsPersistenceKey];

    return propertyList;
}

@end
