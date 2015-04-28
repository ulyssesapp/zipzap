//
//  RKDOCXParagraphAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

// Names required by text lists
extern NSString *RKDOCXParagraphElementName;
extern NSString *RKDOCXParagraphPropertiesElementName;

/*!
 @abstract Generates a paragraph properties element "<w:pPr>" to be added to the parent document.
 @discussion See ISO 29500-1:2012: §17.3.1.26 (Paragraph Properties).
 */
@interface RKDOCXParagraphWriter : NSObject

/*!
 @abstract Returns an XML element representing a paragraph including properties and runs.
 @discussion See ISO 29500-1:2012: §17.3.1 (Paragraphs).
 */
+ (NSXMLElement *)paragraphElementFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a paragraph including a run with a page break.
 */
+ (NSXMLElement *)paragraphElementWithPageBreak;

@end
