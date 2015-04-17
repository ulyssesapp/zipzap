//
//  RKDOCXImageWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Generates a run element "<w:r>" with "w:drawing" as child element to be added to the parent paragraph.
 @discussion See ISO 29500-1:2012: §20 (DrawingML).
 */
@interface RKDOCXImageWriter : NSObject

/*!
 @abstract Returns an XML element representing a run with an XML tree representing the given image attribute.
 */
+ (NSXMLElement *)runElementWithImageAttachment:(RKImageAttachment *)imageAttachment inRunElement:(NSXMLElement *)runElement usingContext:(RKDOCXConversionContext *)context;

@end
