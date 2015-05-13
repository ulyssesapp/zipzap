//
//  RKDOCXStyleTemplateWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 29.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract Generates the style template file containing all style templates referenced by the given context and adds them to the output document.
 @discussion See ISO 29500-1:2012: §17.7 (Styles). The templates will be stored in the styles.xml file inside the output document. Should be called after the main document translation.
 */
@interface RKDOCXStyleTemplateWriter : RKDOCXPartWriter

/*!
 @abstract Writes the style templates of the conversion context and adds the data object to the context.
 */
+ (void)buildStyleTemplatesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the reference element for a paragraph style, if mentioned in the attributes.
 @discussion See ISO 29500-1:2012: §17.3.1.27 (Referenced Paragraph Style).
 */
+ (NSXMLElement *)paragraphStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the reference element for a character style, if mentioned in the attributes.
 @discussion See ISO 29500-1:2012: §17.3.2.29 (Referenced Character Style).
 */
+ (NSXMLElement *)characterStyleReferenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

@end
