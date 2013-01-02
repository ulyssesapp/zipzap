//
//  RKTextTab.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextTab.h"

@implementation RKTextTab

- (id)initWithTabStopType:(NSUInteger)initialTabStopType location:(CGFloat)initialLocation
{
    self = [self init];
    
    if (self) {
        self.tabStopType = initialTabStopType;
        self.location = initialLocation;
    }
    
    return self;
}

+ (RKTextTab *)textTabFromCoreTextRepresentation:(CTTextTabRef)textTab
{
    RKTextTab *convertedTab = [RKTextTab new];
    
    convertedTab.tabStopType = CTTextTabGetAlignment(textTab);
    convertedTab.location = CTTextTabGetLocation(textTab);
    
    return convertedTab;
}

- (CTTextTabRef)coreTextRepresentation
{
    return CTTextTabCreate(_tabStopType, _location, 0);
}

#if !TARGET_OS_IPHONE

+ (RKTextTab *)textTabFromTargetSpecificRepresentation:(NSTextTab *)textTab
{
    RKTextTab *convertedTab = [RKTextTab new];
    convertedTab.tabStopType = textTab.tabStopType;
    convertedTab.location = textTab.location;
    
    return convertedTab;
}

- (id)targetSpecificRepresentation
{
    return [[NSTextTab alloc] initWithType:self.tabStopType location:self.location];
}

#else

+ (RKTextTab *)textTabFromTargetSpecificRepresentation:(id)textTab
{
    return [self textTabFromCoreTextRepresentation: (__bridge CTTextTabRef)textTab];
}

- (id)targetSpecificRepresentation
{
    return (__bridge id)[self coreTextRepresentation];
}

#endif


@end
