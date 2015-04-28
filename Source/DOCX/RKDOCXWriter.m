//
//  RKDOCXWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXWriter.h"

#import "RKDOCXContentTypesWriter.h"
#import "RKDOCXConversionContext.h"
#import "RKDOCXDocumentContentWriter.h"
#import "RKDOCXDocumentPropertiesWriter.h"
#import "RKDOCXFootnotesWriter.h"
#import "RKDOCXListStyleWriter.h"
#import "RKDOCXPartWriter.h"
#import "RKDOCXRelationshipsWriter.h"
#import "RKDOCXSettingsWriter.h"

@implementation RKDOCXWriter

+ (NSData *)DOCXfromDocument:(RKDocument *)document
{
	RKDOCXConversionContext *context = [[RKDOCXConversionContext alloc] initWithDocument: document];
	
	[RKDOCXRelationshipsWriter buildPackageRelationshipsUsingContext: context];
	[RKDOCXDocumentContentWriter buildDocumentUsingContext: context];
	[RKDOCXSettingsWriter buildSettingsUsingContext: context];
	[RKDOCXFootnotesWriter buildFootnotesUsingContext: context];
	[RKDOCXListStyleWriter buildNumberingDefinitionsUsingContext: context];
	[RKDOCXDocumentPropertiesWriter buildCorePropertiesUsingContext: context];
	[RKDOCXDocumentPropertiesWriter buildExtendedPropertiesUsingContext: context];
	[RKDOCXRelationshipsWriter buildDocumentRelationshipsUsingContext: context];
	[RKDOCXContentTypesWriter buildContentTypesUsingContext: context];
	
	return [context docxRepresentation];
}

@end
