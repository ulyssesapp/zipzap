//
//  RKDOCXListStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

@interface RKDOCXListStyleWriter : RKDOCXPartWriter

+ (void)buildNumberingsUsingContxt:(RKDOCXConversionContext *)context;

@end
