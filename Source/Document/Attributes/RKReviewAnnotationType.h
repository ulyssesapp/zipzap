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
 @const RKReviewModeInsertion			The string should be treated as an inserted string
 */
typedef enum : NSUInteger {
	RKReviewAnnotationTypeNone,
	RKReviewAnnotationTypeDeletion,
	RKReviewAnnotationTypeInsertion,
} RKReviewAnnotationType;

extern NSString *RKReviewAnnotationTypeAttributeName;

/*!
 @abstract Provides convenience methods for creating review strings
 */
@interface NSAttributedString (RKAttributedStringReviewAnnotationTypeConvenience)

/*!
 @abstract Creates an attributed string containing review text
 */
+ (NSAttributedString *)attributedStringWithReviewMode:(RKReviewAnnotationType)reviewAnnotation string:(NSString *)string;

@end
