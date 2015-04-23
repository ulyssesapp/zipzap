//
//  RKDOCXSettingsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract Generates the settings file with all document-wide settings used by the given context and adds it to the output document.
 @discussion See ISO 29500-1:2012: §17.15 (Settings). The settings will be stored inside the settings.xml file inside the output document. Should be called before the main document translation.
 */
@interface RKDOCXSettingsWriter : RKDOCXPartWriter

/*!
 @abstract Writes the document settings of the conversion context and adds the data object to the context.
 */
+ (void)buildSettingsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the document-wide endnote/footnote properties element.
 @discussion See ISO 29500-1:2012: §17.11.21 (Footnote Placement), §17.11.22 (Endnote Placement), §17.11.17 (Endnote Enumeration Style), §17.11.18 (Footnote Enumeration Style) and §17.11.19 (Endnote and Footnote Enumeration Policy)
 */
+ (NSXMLElement *)footnotePropertiesFromDocument:(RKDocument *)document isEndnote:(BOOL)isEndnote;

@end
