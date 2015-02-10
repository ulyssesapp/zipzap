//
//  RKOperationHandle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 09/02/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKOperationHandle.h"

@interface RKOperationHandle ()

// Internal write accessor
@property(nonatomic, getter=isCancelled) BOOL cancelled;

@end

@implementation RKOperationHandle

- (void)cancel
{
	self.cancelled = YES;
}

@end
