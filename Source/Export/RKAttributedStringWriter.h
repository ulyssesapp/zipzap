//
//  RKAttributedStringWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKWriter.h"

/*!
 @abstract Translates an attributed string to RTF
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors.
 */
@interface RKAttributedStringWriter : NSObject

/*!
 @abstract Converts an attributes string to RTF
 */
+ (NSString *)RTFfromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end
