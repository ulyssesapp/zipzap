//
//  RKListStyle+RKPersistence.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKListStyle (RKPersistence)

/*!
 @abstract Initializes the given list style with a property list
 */
- (id)initWithPropertyList:(id)propertyList;

/*!
 @abstract Passes a property-list representation of a list style
 */
- (id)propertyListRepresentation;

@end
