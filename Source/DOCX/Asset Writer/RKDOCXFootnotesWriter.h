//
//  RKDOCXFootnotesWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 16.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

extern NSString *RKDOCXReferenceTypeAttributeName;

/*!
 @abstract Generates the footnotes and endnotes files containing all footnotes and endnotes referenced by the given context and adds them to the output document.
 @discussion See ISO 29500-1:2012: §17.11 (Footnotes and Endnotes). The footnotes will be stored in the footnotes.xml file and the endnotes in the endnotes.xml file inside the output document. Should be called after the main document translation.
 */
@interface RKDOCXFootnotesWriter : RKDOCXPartWriter

/*!
 @abstract Writes the footnotes and endnotes of the conversion context and adds the data objects to the context.
 */
+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an entire run element containing the reference element (inside the document content).
 */
+ (NSXMLElement *)referenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an entire run element containing the reference’s mark and content (inside the footnotes area).
 */
+ (NSXMLElement *)referenceMarkForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

@end
