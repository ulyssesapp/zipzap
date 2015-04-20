//
//  RKDOCXImageWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Converter for image run elements.
 */
@interface RKDOCXImageWriter : NSObject

/*!
 @abstract Converts the passed image attachment to an entire run element.
 */
+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

@end
