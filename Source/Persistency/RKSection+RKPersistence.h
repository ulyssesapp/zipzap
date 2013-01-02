//
//  RKSection+RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

@interface RKSection (RKPersistence)

/*!
 @abstract Initializes an RKSection with its property list representation
 */
- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error;

/*!
 @abstract Serializes a RKSection to a property list representation
 */
- (id)RTFKitPropertyListRepresentation;

@end
