//
//  RKDOCXConversionContext.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

extern NSString *RKDOCXConversionContextRelationshipTypeName;
extern NSString *RKDOCXConversionContextRelationshipIdentifierName;

/*!
 @abstract Collects state generated during the conversion process that is shared between conversion steps.
 @discussion This includes the final DOCX output, as well as any intermediate state shared between different conversion passes.
 */
@interface RKDOCXConversionContext : NSObject

/*!
 @abstract Initializes the conversion context with a document the conversion process is operating on.
 */
- (instancetype)initWithDocument:(RKDocument *)document;

/*!
 @abstract The document a conversion context belongs to.
 */
@property (nonatomic, readonly) RKDocument *document;


#pragma mark - Output context

/*!
 @abstract The data representation of the generated DOCX file as far as collected.
 @discussion Should be used only after performing all required conversion steps.
 */
@property (nonatomic, readonly) NSData *docxRepresentation;


#pragma mark - Document relationships

/*!
 @abstract Mapping from relationship targets (NSString) to relationship identifiers (NSNumber).
 */
@property (nonatomic, readonly) NSDictionary *documentRelationships;
#warning Make sure there are no duplicates in relationships.

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename;

/*!
 @abstract Returns the relationship identifier of a target.
 @discussion Also creates a new identifier if needed.
 */
- (NSUInteger)indexForRelationshipWithTarget:(NSString *)target andType:(NSString *)type;

@end
