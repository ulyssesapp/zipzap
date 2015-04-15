//
//  RKDOCXImageWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

@interface RKDOCXImageWriter : NSObject

+ (NSXMLElement *)runElementWithImageAttachment:(RKImageAttachment *)imageAttachment inRunElement:(NSXMLElement *)runElement usingContext:(RKDOCXConversionContext *)context;

@end
