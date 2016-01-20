//
//  RKDOCXReviewAnnotationWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract Creates container elements for inserted, deleted and annotated run elements.
 */
@interface RKDOCXReviewAnnotationWriter : RKDOCXPartWriter

/*!
 @abstract Generates the comments file containing all comments referenced by the given context and adds them to the output document.
 @discussion See ISO 29500-1:2012: §17.13.4 (Comments). The comments will be stored in the comments.xml file inside the output document. Should be called after the main document translation.
 */
+ (void)buildCommentsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an empty 'w:del' element that has yet to be filled.
 */
+ (NSXMLElement *)containerElementForDeletedRunsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an empty 'w:ins' element that has yet to be filled.
 */
+ (NSXMLElement *)containerElementForInsertedRunsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the start element of a comment if the comment exists.
 */
+ (NSXMLElement *)startElementForCommentAttribute:(NSAttributedString *)comment withID:(NSUInteger *)commentID usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns the end and reference elements of a comment using the given comment ID.
 */
+ (NSArray *)endElementsForCommentID:(NSUInteger)commentID usingContext:(RKDOCXConversionContext *)context;

@end
