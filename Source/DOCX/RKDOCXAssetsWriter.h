//
//  RKDOCXAssetsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXConversionContext;

@interface RKDOCXAssetsWriter : NSObject

/*!
 @abstract Builds the relationship NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the content types NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the core properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildCorePropertiesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the extended properties NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildExtendedPropertiesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the document relationship NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the settings NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Builds the main document NSXMLDocument of the DOCX package and adds it to the RKDOCXContextObject.
 */
+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context;

@end
