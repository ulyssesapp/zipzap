//
//  RKDOCXSettingsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"
#import "RKDOCXConversionContext.h"

@interface RKDOCXSettingsWriter : RKDOCXPartWriter

/*!
 @abstract Writes the document settings of the conversion context and adds the data object to the context.
 */
+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context;

@end
