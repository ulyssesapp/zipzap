//
//  RKOperationHandle.h
//  RTFKit
//
//  Created by Friedrich Gräter on 09/02/15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract An object that allows to control running conversion operations.
 */
@interface RKOperationHandle : NSObject

/*!
 @abstract Whether or not the operation has been canceled.
 */
@property(nonatomic, readonly, getter=isCancelled) BOOL cancelled;

/*!
 @abstract Cancels an operation if it is still running.
 */
- (void)cancel;

@end
