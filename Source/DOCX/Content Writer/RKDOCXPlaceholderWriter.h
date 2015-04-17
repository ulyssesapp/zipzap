//
//  RKDOCXPlaceholderWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract Converter for placeholder run elements.
 */
@interface RKDOCXPlaceholderWriter : NSObject

/*!
 @abstract Converts the passed placeholder to an entire run element.
 @discussion DOCX only supports page number placeholders. See ISO 29500-1:2012: §17.16.19 (Simple Field).
 */
+ (NSXMLElement *)placeholder:(NSNumber *)placeholder withRunElementName:(NSString *)runElementName textElementName:(NSString *)textElementName;

@end
