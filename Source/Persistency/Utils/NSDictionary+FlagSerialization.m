//
//  NSDictionary+FlagSerialization.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSDictionary+FlagSerialization.h"

@implementation NSDictionary (FlagSerialization)

- (NSArray *)arrayFromFlags:(NSUInteger)flags
{
    NSMutableArray *serializedFlags = [NSMutableArray new];
    __block NSUInteger cleanedFlags = flags;

    // Sort flags, so we can detect multi-bit flags that imply other flags
    NSArray *sortedFlags = [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        if ([[self objectForKey: key1] unsignedIntegerValue] < [[self objectForKey: key2] unsignedIntegerValue])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    // Detect flags that have been set so far
    [sortedFlags enumerateObjectsUsingBlock:^(NSString *flagName, NSUInteger idx, BOOL *stop) {
        NSNumber *flag = [self objectForKey: flagName];
        NSUInteger flagValue = flag.unsignedIntegerValue;
        
        if (flagValue == 0) {
            if (cleanedFlags == 0) {
                // We have a flag with value 0, and we should serialize 0.
                [serializedFlags addObject: flagName];
                *stop = YES;
            }
            
            // 0-flags are only serialized, if requested and if no other flags are set
            return;
        }
        
        // We have a flag with a value
        if (cleanedFlags & flagValue) {
            [serializedFlags addObject: flagName];
            cleanedFlags &= ~flagValue;
        }
    }];
    
    NSAssert(cleanedFlags == 0, @"Some flags missed");
    
    return serializedFlags;
}

- (NSUInteger)flagsFromArray:(NSArray *)serializedFlags error:(NSError **)error
{
    NSUInteger flags = 0;
    
    for (NSString *flagName in serializedFlags) {
        NSNumber *flagPrototype = [self objectForKey: flagName];
        if (!flagPrototype) {
            if (error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObject:@"Incompatible format." forKey:NSLocalizedDescriptionKey]];
            return 0;
        }
        
        flags |= flagPrototype.unsignedIntegerValue;
    }
    
    return flags;
}

- (NSString *)stringFromUnsignedEnumValue:(NSUInteger)enumValue
{
    __block NSString *enumString = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *enumKey, NSNumber *enumPrototype, BOOL *stop) {
        NSUInteger enumPrototypeValue = enumPrototype.unsignedIntegerValue;
        
        if (enumPrototypeValue == enumValue) {
            *stop = YES;
            enumString = enumKey;
            return;
        }
    }];
    
    NSParameterAssert(enumString);
    
    return enumString;
}

- (NSUInteger)unsignedEnumValueFromString:(NSString *)serializedEnumValue error:(NSError **)error
{
    NSNumber *enumPrototype = [self objectForKey: serializedEnumValue];
    if (!enumPrototype) {
        if (error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObject:@"Incompatible format." forKey:NSLocalizedDescriptionKey]];
        return 0;
    }
    
    return enumPrototype.unsignedIntegerValue;
}

- (NSString *)stringFromSignedEnumValue:(NSInteger)enumValue
{
    __block NSString *enumString = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *enumKey, NSNumber *enumPrototype, BOOL *stop) {
        NSUInteger enumPrototypeValue = enumPrototype.integerValue;
        
        if (enumPrototypeValue == enumValue) {
            *stop = YES;
            enumString = enumKey;
            return;
        }
    }];
    
    NSParameterAssert(enumString);
    
    return enumString;
}

- (NSInteger)signedEnumValueFromString:(NSString *)serializedEnumValue error:(NSError **)error
{
    NSNumber *enumPrototype = [self objectForKey: serializedEnumValue];
    if (!enumPrototype) {
        if (error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObject:@"Incompatible format." forKey:NSLocalizedDescriptionKey]];
        return 0;
    }
    
    return enumPrototype.integerValue;
}

@end