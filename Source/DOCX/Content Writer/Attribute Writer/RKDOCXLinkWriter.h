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
 @discussion linkAttribute must be either of type NSURL or NSString.
 */
+ (NSXMLElement *)linkElementForAttribute:(id)linkAttribute usingContext:(RKDOCXConversionContext *)context;

@end
