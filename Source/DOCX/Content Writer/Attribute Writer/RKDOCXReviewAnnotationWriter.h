//
//  RKDOCXReviewAnnotationWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

/*!
 @abstract Creates container elements for inserted, deleted and annotated run elements.
 */
@interface RKDOCXReviewAnnotationWriter : NSObject

/*!
 @abstract Returns an empty 'w:del' element that has yet to be filled.
 */
+ (NSXMLElement *)containerElementForDeletedRunsUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an empty 'w:ins' element that has yet to be filled.
 */
+ (NSXMLElement *)containerElementForInsertedRunsUsingContext:(RKDOCXConversionContext *)context;

@end
