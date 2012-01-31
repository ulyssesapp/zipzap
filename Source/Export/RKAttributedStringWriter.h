//
//  RKAttributedStringWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKWriter.h"
#import "RKAttributeWriter.h"

/*!
 @abstract Translates an attributed string to RTF
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors.
 */
@interface RKAttributedStringWriter : NSObject

/*!
 @abstract Registers a handler class for writing out an attribute to RTF
 @discussion The class has to inherit from RKAttributeWriter
 */
+ (void)registerHandler:(Class)attributeWriter forAttribute:(NSString*)attributeName;

/*!
 @abstract Converts an attributes string to RTF
 */
+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end
