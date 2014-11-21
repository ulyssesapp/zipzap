//
//  RKPortableAttributeNames-iOS.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import <CoreText/CoreText.h>

#if TARGET_OS_IPHONE

/*!
 @abstract Pre-initialized attribute names
 @discussion Internally used, please use the RK*AttributeName macros instead.
 */
extern NSString *__RKBackgroundColorAttributeName;
extern NSString *__RKLinkAttributeName;
extern NSString *__RKAttachmentAttributeName;
extern NSString *__RKStrikethroughStyleAttributeName;
extern NSString *__RKStrikethroughColorAttributeName;
extern NSString *__RKShadowAttributeName;
extern NSString *__RKBaselineOffsetAttributeName;
extern NSString *__RKLigatureAttributeName;
extern NSString *__RKKernAttributeName;
extern NSString *__RKObliquenessAttributeName;

/*!
 @abstract Meta data style names
 @discussion See NS*DocumentAttribute constants from the MacOS developer library
 */
extern NSString *RKTitleDocumentAttribute;      
extern NSString *RKCompanyDocumentAttribute;    
extern NSString *RKCopyrightDocumentAttribute;  
extern NSString *RKSubjectDocumentAttribute;    
extern NSString *RKAuthorDocumentAttribute;     
extern NSString *RKKeywordsDocumentAttribute;   
extern NSString *RKCommentDocumentAttribute;    
extern NSString *RKEditorDocumentAttribute;     
extern NSString *RKCreationTimeDocumentAttribute;
extern NSString *RKModificationTimeDocumentAttribute;
extern NSString *RKManagerDocumentAttribute; 
extern NSString *RKCategoryDocumentAttribute;

/*!
 @abstract Name of a font attribute
 @discussion See NSFontAttributeName
 */
#define RKFontAttributeName						NSFontAttributeName

/*!
 @abstract Background color
 @discussion See NSBackgroundColorAttributeName
 */
#define RKBackgroundColorAttributeName			NSBackgroundColorAttributeName

/*!
 @abstract Foreground color
 @discussion See NSForegroundColorAttributeName
 */
#define RKForegroundColorAttributeName			NSForegroundColorAttributeName

/*!
 @abstract Underline style
 @discussion See kCTUnderlineStyleAttributeName
 */
#define RKUnderlineStyleAttributeName			NSUnderlineStyleAttributeName

/*!
 @abstract Underline color
 @discussion See NSUnderlineColorAttributeName
 */
#define RKUnderlineColorAttributeName			NSUnderlineColorAttributeName

/*!
 @abstract Strikethrough style
 @discussion Uses a NSNumber as value that may use the RKUnderlineStyle flags.
 */
#define RKStrikethroughStyleAttributeName		NSStrikethroughStyleAttributeName

/*!
 @abstract Strikethrough color
 @discussion See NSStrikethroughColorAttributeName.
 */
#define RKStrikethroughColorAttributeName		NSStrikethroughColorAttributeName

/*!
 @abstract Stroke color
 @discussion See NSStrokeColorAttributeName
 */
#define RKStrokeColorAttributeName				NSStrokeColorAttributeName

/*!
 @abstract Stroke width
 @discussion See kCTStrokeWidthAttributeName
 */
#define RKStrokeWidthAttributeName				NSStrokeWidthAttributeName

/*!
 @abstract Link attribute
 @discussion The value must be either a NSString or NSURL object
 */
#define RKLinkAttributeName						NSLinkAttributeName

/*!
 @abstract Text attachment attribute
 @discussion The value must be an RKTextAttachment object
 */
#define RKAttachmentAttributeName				NSAttachmentAttributeName

/*!
 @abstract Superscript attribute
 @discussion See kCTSuperscriptAttributeName
 */
#define RKSuperscriptAttributeName				((NSString *)kCTSuperscriptAttributeName)

/*!
 @abstract Paragraph style attribute
 @discussion See NSParagraphStyleAttributeName
 */
#define RKParagraphStyleAttributeName			NSParagraphStyleAttributeName

/*!
 @abstract Shadow attribute
 @discussion Requires a RKShadow value.
 */
#define RKShadowAttributeName					__RKShadowAttributeName

/*!
 @abstract Baseline attribute
 @discussion Number with float containing the baseline offset
 */
#define RKBaselineOffsetAttributeName			NSBaselineOffsetAttributeName

/*!
 @abstract Ligatur attribute
 */
#define RKLigatureAttributeName					NSLigatureAttributeName

/*!
 @abstract Kerning attribute
 @discussion Number with float containing the kerning offset
 */
#define RKKernAttributeName						NSKernAttributeName

/*!
 @abstract Obliqueness attribute
 */
#define RKObliquenessAttributeName				NSObliquenessAttributeName

/*!
 @abstract Underlining styles
 @discussion See kCTUnderlineStyle constants
 */
#define RKUnderlineStyleNone                    kCTUnderlineStyleNone
#define RKUnderlineStyleSingle					kCTUnderlineStyleSingle
#define RKUnderlineStyleDouble                  kCTUnderlineStyleDouble
#define RKUnderlineStyleThick                   kCTUnderlineStyleThick

/*!
 @abstract Underlining mask
 @discussion Cannot be used on iOS for RKUnderlineStyleAttributeName
 */
#define RKUnderlineByWordMask                   ((NSUInteger)0x1000)

/*!
 @abstract Underlining pattern
 @discussion See kCTUnderlinePattern constants
 */
#define RKUnderlinePatternDot                   kCTUnderlinePatternDot
#define RKUnderlinePatternDash                  kCTUnderlinePatternDash
#define RKUnderlinePatternDashDot               kCTUnderlinePatternDashDot
#define RKUnderlinePatternDashDotDot            kCTUnderlinePatternDashDotDot

/*!
 @abstract Character used to denote a text attachment
 */
#define RKAttachmentCharacter                   ((unichar)0xfffc)

/*!
 @abstract Character used to denote newlines (not paragraph breaks)
 */
#define RKLineSeparatorCharacter                ((unichar)0x2028)

/*!
 @abstract Text alignment settings.
 */
#define RKTextAlignmentLeft						NSTextAlignmentLeft
#define RKTextAlignmentRight					NSTextAlignmentRight
#define RKTextAlignmentNatural					NSTextAlignmentNatural
#define RKTextAlignmentCenter					NSTextAlignmentCenter
#define RKTextAlignmentJustified				NSTextAlignmentJustified

/*!
 @abstract Alignment conversion
 */
#define RKTextAlignmentToCTTextAlignment(__nsAlignment)		NSTextAlignmentToCTTextAlignment(__nsAlignment)
#define RKTextAlignmentFromCTTextAlignment(__ctAlignment)	NSTextAlignmentFromCTTextAlignment(__ctAlignment)

#endif
