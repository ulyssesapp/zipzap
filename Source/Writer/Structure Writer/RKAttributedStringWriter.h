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
 @abstract Defines a priority for an attributed string writer
 @const
    RKAttributedStringWriterPriorityParagraphLevel              The highest priority used for paragraph tags
    RKAttributedStringWriterPriorityParagraphStylingLevel       Priority used for additional paragraph stylings
    RKAttributedStringWriterPriorityInlineStyleLevel            Priority used for inline styles
    RKAttributedStringWriterPriorityTextAttachmentLevel         Priority used for text attachments
*/
typedef enum {
    RKAttributedStringWriterPriorityParagraphLevel = 0,
    RKAttributedStringWriterPriorityParagraphStylingLevel = 1,
    RKAttributedStringWriterPriorityInlineStyleLevel = 2,
    RKAttributedStringWriterPriorityTextAttachmentLevel = 3
} RKAttributedStringWriterPriority;

/*!
 @abstract Translates an attributed string to RTF
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors.
 */
@interface RKAttributedStringWriter : NSObject

/*!
 @abstract Registers a handler class for writing out an attribute to RTF
 @discussion The class has to inherit from RKAttributeWriter. 
             If the handler is added with priority, it will be executed before all non-priorized handlers.
             Calls addTagsForAttribute:toTaggedString:inRange:ofAttributedString:withAttachmentPolicy:resources: on the handler.
 */
+ (void)registerWriter:(Class)attributeWriter forAttribute:(NSString*)attributeName priority:(RKAttributedStringWriterPriority)priority;

/*!
 @abstract Converts an attributes string to RTF
 */
+ (NSString *)RTFFromAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end
