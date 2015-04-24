//
//  RKDOCXLinkWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Converter for link run elements.
 */
@interface RKDOCXLinkWriter : NSObject

/*!
 @abstract Converts the passed link attachment to a hyperlink element.
 */
+ (NSXMLElement *)linkElementForAttribute:(NSURL *)linkAttribute usingContext:(RKDOCXConversionContext *)context;

@end
