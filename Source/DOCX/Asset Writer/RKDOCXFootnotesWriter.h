//
//  RKDOCXFootnotesWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 16.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

extern NSString *RKDOCXFootnoteReferenceAttributeName;

/*!
 @abstract Generates the footnotes file containing all footnotes referenced be the given context and adds it to the output document.
 @discussion See ISO 29500-1:2012: §17.11 (Footnotes and Endnotes). The footnotes will be stored in the footnotes.xml file inside the output document. Should be called after the main document translation.
 */
@interface RKDOCXFootnotesWriter : RKDOCXPartWriter

/*!
 @abstract Writed the footnotes of the conversion context and adds the data object to the context.
 */
+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context;

+ (NSXMLElement *)footnoteReferenceElementForFootnoteString:(NSAttributedString *)footnoteString inRunElement:(NSXMLElement *)runElement usingContext:(RKDOCXConversionContext *)context;

+ (NSXMLElement *)footnoteReferenceMarkWithRunElementName:(NSString *)runElementName runPropertiesElementName:(NSString *)runPropertiesElementName;

@end
