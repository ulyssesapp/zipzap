//
//  RKDOCXWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXWriter.h"
#import "RKDOCXConversionContext.h"
#import "RKDOCXAssetsWriter.h"

@implementation RKDOCXWriter

+ (NSData *)DOCXfromDocument:(RKDocument *)document
{
	RKDOCXConversionContext *context = [[RKDOCXConversionContext alloc] initWithDocument: document];
	
	[RKDOCXAssetsWriter buildPackageRelationshipsUsingContext: context];
	[RKDOCXAssetsWriter buildContentTypesUsingContext: context];
	[RKDOCXAssetsWriter buildCorePropertiesUsingContext: context];
	[RKDOCXAssetsWriter buildExtendedPropertiesUsingContext: context];
	[RKDOCXAssetsWriter buildDocumentRelationshipsUsingContext: context];
	[RKDOCXAssetsWriter buildSettingsUsingContext: context];
	[RKDOCXAssetsWriter buildDocumentUsingContext: context];
	
	return [context docxRepresentation];
}

@end
