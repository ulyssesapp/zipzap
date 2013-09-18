//
//  RKAttributedStringWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversionPolicy.h"
#import "RKResourcePool.h"
#import "RKWriter.h"
#import "RKAttributeWriter.h"

/*!
 @abstract Defines a priority for an attributed string writer
 @const
    RKAttributedStringWriterPriorityParagraphLevel                      Priority used for paragraph tags
    RKAttributedStringWriterPriorityParagraphStyleSheetLevel            Priority used for paragraph style sheets
    RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel     Priority used for additional paragraph stylings
    RKAttributedStringWriterPriorityInlineStylesheetLevel               Priority used for inline stylesheets
    RKAttributedStringWriterPriorityInlineStyleLevel                    Priority used for inline styles
    RKAttributedStringWriterPriorityTextAttachmentLevel                 Priority used for text attachments
*/
typedef enum : NSUInteger {
    RKAttributedStringWriterPriorityParagraphLevel = 0,
    RKAttributedStringWriterPriorityParagraphStyleSheetLevel = 1,
    RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel = 2,
    RKAttributedStringWriterPriorityInlineStylesheetLevel = 3,
    RKAttributedStringWriterPriorityInlineStyleLevel = 4,
    RKAttributedStringWriterPriorityTextAttachmentLevel = 5
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
             Calls addTagsForAttribute:toTaggedString:inRange:ofAttributedString:withConversionPolicy:resources: on the handler.
 */
+ (void)registerWriter:(Class)attributeWriter forAttribute:(NSString*)attributeName priority:(RKAttributedStringWriterPriority)priority;

/*!
 @abstract Returns all style sheet tags required for a certain attribute dictionary
 */
+ (NSString *)stylesheetTagsFromAttributes:(NSDictionary *)attributes resources:(RKResourcePool *)resources;

/*!
 @abstract Adjusts all attributes of an attributed string by executing style-specific preprocessing methods
 @discussion The generated attributed string will be finally used for RTF generation.
 */
+ (NSAttributedString *)attributedStringByAdjustingStyles:(NSAttributedString *)attributedString usingPreprocessingPolicy:(RKAttributePreprocessingPolicy)preprocessingPolicy;

/*!
 @abstract Converts an attributed string to RTF
 */
+ (NSString *)RTFFromAttributedString:(NSAttributedString *)attributedString withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

@end