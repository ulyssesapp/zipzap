//
//  RKReviewAnnotationType.h
//  RTFKit
//
//  Created by Lucas Hauswald on 15.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

/*!
 @abstract Possible annotation types
 
 @const RKReviewAnnotationTypeNone		The string should be treated as a normal string
 @const RKReviewAnnotationTypeDeletion	The string should be treated as a deleted string
 @const RKReviewAnnotationInsertion		The string should be treated as an inserted string
 */
typedef enum : NSUInteger {
	RKReviewAnnotationTypeNone,
	RKReviewAnnotationTypeDeletion,
	RKReviewAnnotationTypeInsertion,
} RKReviewAnnotationType;

/*!
 @abstract Attribute name for referencing review annotation types.
 @discussion Can be of type RKReviewAnnotationType, with the default being RKReviewAnnotationTypeNone.
 */
extern NSString *RKReviewAnnotationTypeAttributeName;
