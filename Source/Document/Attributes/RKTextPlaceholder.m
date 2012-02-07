//
//  RKTextPlaceholder.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextPlaceholder.h"


NSString *RKTextPlaceholderAttributeName = @"RKTextPlaceholder";

/*!
 @abstract Represents a certain variable content
 @discussion e.g. Page numbers, Section numbers
 */
@implementation RKTextPlaceholder : NSObject

@synthesize placeholderType;

+ (RKTextPlaceholder*)placeholderWithType:(RKTextPlaceholderType)placeholderType
{
    return [[self alloc] initWithPlaceholderType:placeholderType]; 
}

- (id)initWithPlaceholderType:(RKTextPlaceholderType)placeholderType
{
    self = [self init];
    
    if (self) {
        self.placeholderType = placeholderType;
    }
    
    return self;
}

@end
