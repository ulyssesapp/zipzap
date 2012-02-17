//
//  RKInlineStyleWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 17.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriter.h"

/*!
 @abstract An abstract class used to build inline style writers
 @discussion This class automatically provides an implementation for all template methods of RKAttributeWriter using a definition of opening and closing tags
 */
@interface RKInlineStyleWriter : RKAttributeWriter

/*!
 @abstract Abstract method that delivers an opening tag for a certain inline style
 @discussion Returns an empty string, if the attribute is inactive
 */
+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources;

/*!
 @abstract Abstract method that delivers an closing tag for a certain inline style
 @discussion Returns an empty string, if the attribute is inactive or must not be closed
 */
+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources;

@end
