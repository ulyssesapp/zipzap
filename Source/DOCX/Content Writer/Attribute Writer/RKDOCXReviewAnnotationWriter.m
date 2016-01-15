//
//  RKDOCXReviewAnnotationWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

#import "RKDOCXReviewAnnotationWriter.h"

NSString *RKDOCXDeletedElementName	= @"w:del";
NSString *RKDOCXIDAttributeName		= @"w:id";
NSString *RKDOCXInsertedElementName	= @"w:ins";

@implementation RKDOCXReviewAnnotationWriter

+ (NSXMLElement *)containerElementForDeletedRunsUsingContext:(RKDOCXConversionContext *)context
{
	return [NSXMLElement elementWithName:RKDOCXDeletedElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:context.newReviewId]]];
}

+ (NSXMLElement *)containerElementForInsertedRunsUsingContext:(RKDOCXConversionContext *)context
{
	return [NSXMLElement elementWithName:RKDOCXInsertedElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:context.newReviewId]]];
}

@end
