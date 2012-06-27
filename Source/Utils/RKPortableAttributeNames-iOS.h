//
//  RKPortableAttributeNames-iOS.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

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
 @discussion See kCTFontAttributeName
 */
#define RKFontAttributeName                     (__bridge NSString *)kCTFontAttributeName

/*!
 @abstract Background color
 @discussion Uses a CGColor object as value
 */
#define RKBackgroundColorAttributeName          __RKBackgroundColorAttributeName

/*!
 @abstract Foreground color
 @discussion See kCTForegroundCollorAttributeName
 */
#define RKForegroundColorAttributeName          (__bridge NSString *)kCTForegroundColorAttributeName

/*!
 @abstract Underline style
 @discussion See kCTUnderlineStyleAttributeName
 */
#define RKUnderlineStyleAttributeName           (__bridge NSString *)kCTUnderlineStyleAttributeName

/*!
 @abstract Underline color
 @discussion See kCTUnderlineStyleAttributeName
 */
#define RKUnderlineColorAttributeName           (__bridge NSString *)kCTUnderlineColorAttributeName

/*!
 @abstract Strikethrough style
 @discussion Uses a NSNumber as value that may use the RKUnderlineStyle flags.
 */
#define RKStrikethroughStyleAttributeName       __RKStrikethroughStyleAttributeName

/*!
 @abstract Strikethrough color
 @discussion Uses a CGColor value.
 */
#define RKStrikethroughColorAttributeName       __RKStrikethroughColorAttributeName

/*!
 @abstract Stroke color
 @discussion See kCTStrokeColorAttributeName
 */
#define RKStrokeColorAttributeName              (__bridge NSString *)kCTStrokeColorAttributeName

/*!
 @abstract Stroke width
 @discussion See kCTStrokeWidthAttributeName
 */
#define RKStrokeWidthAttributeName              (__bridge NSString *)kCTStrokeWidthAttributeName

/*!
 @abstract Link attribute
 @discussion The value must be either a NSString or NSURL object
 */
#define RKLinkAttributeName                     __RKLinkAttributeName

/*!
 @abstract Text attachment attribute
 @discussion The value must be an RKTextAttachment object
 */
#define RKAttachmentAttributeName               __RKAttachmentAttributeName

/*!
 @abstract Superscript attribute
 @discussion See kCTSuperscriptAttributeName
 */
#define RKSuperscriptAttributeName              (__bridge NSString *)kCTSuperscriptAttributeName

/*!
 @abstract Paragraph style attribute
 @discussion See kCTParagraphStyleAttributeName
 */
#define RKParagraphStyleAttributeName           (__bridge NSString *)kCTParagraphStyleAttributeName

/*!
 @abstract Shadow attribute
 @discussion Requires a RKShadow value.
 */
#define RKShadowAttributeName                   __RKShadowAttributeName

/*!
 @abstract Underlining styles
 @discussion See kCTUnderlineStyle constants
 */
#define RKUnderlineStyleNone                    kCTUnderlineStyleNone
#define RKUnderlineStyleSingle                  kCTUnderlineStyleSingle
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

#endif
