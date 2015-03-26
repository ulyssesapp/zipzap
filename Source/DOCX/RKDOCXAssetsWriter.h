//
//  RKDOCXAssetsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXContextObject;

@interface RKDOCXAssetsWriter : NSObject

+ (void)buildPackageRelationshipsUsingContext:(RKDOCXContextObject *)context;

+ (void)buildContentTypesUsingContext:(RKDOCXContextObject *)context;

+ (void)buildCorePropertiesUsingContext:(RKDOCXContextObject *)context;

+ (void)buildExtendedPropertiesUsingContext:(RKDOCXContextObject *)context;

+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXContextObject *)context;

@end
