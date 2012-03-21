//
//  RKTextAttachment.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE
/*!
 @abstract Represents a text attachment
 @discussion Only available on iOS
 */
@interface RKTextAttachment : NSObject

/*!
 @abstract Initializes a text attachment with a file wrapper
 */
- (id)initWithFileWrapper:(NSFileWrapper *)fileWrapper;

/*!
 @abstract A file wrapper attached to the text attachment
 */
@property (nonatomic, strong) NSFileWrapper *fileWrapper;

@end
#endif