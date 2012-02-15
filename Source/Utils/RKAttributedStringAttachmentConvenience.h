//
//  RKAttributedStringAttachmentConvenience.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Internally used to create attributed string with an arbitrary text attachment
 */
@interface NSAttributedString (RKAttributedStringAttachmentConvenience)

/*!
 @abstract Creates an attributed string with an arbitrary attachment attribute.
 */
+ (NSAttributedString *)attributedStringWithAttachment:(id)attachment attributeName:(NSString *)attributeName;

@end
