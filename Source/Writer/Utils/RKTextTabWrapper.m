//
//  RKTextTabWrapper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextTabWrapper.h"

@implementation RKTextTabWrapper

@synthesize tabAlignment, location;

- (id)initWithCTTextTab:(CTTextTabRef)textTab
{
    self = [self init];
    
    if (self) {
        tabAlignment = CTTextTabGetAlignment(textTab);
        location = CTTextTabGetLocation(textTab);
    }
    
    return self;
}

- (CTTextTabRef)newCTTextTab
{
    return CTTextTabCreate(tabAlignment, location, NULL);
}

#if !TARGET_OS_IPHONE

- (id)initWithNSTextTab:(NSTextTab *)textTab
{
    self = [self init];
    
    if (self) {
        tabAlignment = textTab.alignment;
        location = textTab.location;
    }
    
    return self;
}

- (NSTextTab *)newNSTextTab
{
    return [[NSTextTab alloc] initWithTextAlignment:tabAlignment location:location options:NULL];
}

#endif

@end
