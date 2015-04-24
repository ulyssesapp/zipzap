//
//  RKDOCXRelationshipsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract The relatationship type used by external hyperlinks. Required by RKDOCXLinkWriter.
 */
extern NSString *RKDOCXLinkRelationshipType;

/*!
 @abstract Generates the listing of all package and document relationships used by the given context and adds it to the output document.
 @discussion See ISO 29500-1:2012: §11.2 (Package Structure). The collected package relationships will be stored inside the _rels/.rels file and the document relationships will be stored inside the word/_rels/.rels file inside the output document. Should be called after the main document translation.
 */
@interface RKDOCXRelationshipsWriter : RKDOCXPartWriter

/*!
 @abstract Collects the package relationships of the conversion context in a _rels/.rels file and adds the data object to the context.
 */
+ (void)buildPackageRelationshipsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Collects the document's relationships of the conversion context in a word/_rels/.rels file and adds the data object to the context.
 @discussion The relationship identifier are created and stored by the conversion context.
 */
+ (void)buildDocumentRelationshipsUsingContext:(RKDOCXConversionContext *)context;

@end
