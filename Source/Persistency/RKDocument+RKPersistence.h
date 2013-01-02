//
//  RKDocument+RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

@interface RKDocument (RKPersistence)

/*!
 @abstract Initializes a RKDocument with its property list representation
 */
- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error;

/*!
 @abstract Serializes a RKDocument to a property list representation
 */
- (id)RTFKitPropertyListRepresentation;

@end
