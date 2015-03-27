//
//  RSDOCXContextObject.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract Contains the zip file version of an RKDocument
 */
@interface RKDOCXContextObject : NSObject

/*!
 @abstract The DOCX archive containing the XML files of a DOCX
 */
@property (nonatomic, readonly) NSData *docxRepresentation;

/*!
 @abstract Initializes the context object with a certain document.
 */
- (id)initWithDocument:(RKDocument *)initialDocument;

/*!
 @abstract The document a context object belongs to.
 */
@property (nonatomic, readonly) RKDocument *document;

/*!
 @abstract NSDictionary containing the relationship target as key and the Id as value.
 */
@property (nonatomic, readonly) NSDictionary *documentRelationships;
// TODO: Make sure there are no duplicates in relationships.

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename;

/*!
 @abstract Adds a new relationship to the dictionary.
 */
- (void)addDocumentRelationshipWithTarget:(NSString *)target forRId:(NSString *)RId;

@end
