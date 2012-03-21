//
//  RKPortableAttributeNames.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if !TARGET_OS_IPHONE

#define RKFontAttributeName                     NSFontAttributeName
#define RKBackgroundColorAttributeName          NSBackgroundColorAttributeName
#define RKForegroundColorAttributeName          NSForegroundColorAttributeName
#define RKUnderlineStyleAttributeName           NSUnderlineStyleAttributeName
#define RKUnderlineColorAttributeName           NSUnderlineColorAttributeName
#define RKStrikethroughStyleAttributeName       NSStrikethroughStyleAttributeName
#define RKStrikethroughColorAttributeName       NSStrikethroughColorAttributeName
#define RKStrokeColorAttributeName              NSStrokeColorAttributeName
#define RKStrokeWidthAttributeName              NSStrokeWidthAttributeName
#define RKLinkAttributeName                     NSLinkAttributeName
#define RKAttachmentAttributeName               NSAttachmentAttributeName
#define RKSuperscriptAttributeName              NSSuperscriptAttributeName
#define RKParagraphStyleAttributeName           NSParagraphStyleAttributeName
#define RKShadowAttributeName                   NSShadowAttributeName

#define RKUnderlineStyleNone                    NSUnderlineStyleNone
#define RKUnderlineStyleSingle                  NSUnderlineStyleSingle
#define RKUnderlineStyleDouble                  NSUnderlineStyleDouble
#define RKUnderlineStyleThick                   NSUnderlineStyleThick

#define RKUnderlineByWordMask                   NSUnderlineByWordMask

#define RKUnderlinePatternDash                  NSUnderlinePatternDash
#define RKUnderlinePatternDashDot               NSUnderlinePatternDashDot
#define RKUnderlinePatternDashDotDot            NSUnderlinePatternDashDotDot

#define RKAttachmentCharacter                   NSAttachmentCharacter

#define RKTitleDocumentAttribute                NSTitleDocumentAttribute
#define RKCompanyDocumentAttribute              NSCompanyDocumentAttribute
#define RKCopyrightDocumentAttribute            NSCopyrightDocumentAttribute
#define RKSubjectDocumentAttribute              NSSubjectDocumentAttribute
#define RKAuthorDocumentAttribute               NSAuthorDocumentAttribute
#define RKKeywordsDocumentAttribute             NSKeywordsDocumentAttribute
#define RKCommentDocumentAttribute              NSCommentDocumentAttribute
#define RKEditorDocumentAttribute               NSEditorDocumentAttribute
#define RKCreationTimeDocumentAttribute         NSCreationTimeDocumentAttribute
#define RKModificationTimeDocumentAttribute     NSModificationTimeDocumentAttribute
#define RKManagerDocumentAttribute              NSManagerDocumentAttribute
#define RKCategoryDocumentAttribute             NSCategoryDocumentAttribute

#elif TARGET_OS_IPHONE

extern NSString *__RKBackgroundColorAttributeName;
extern NSString *__RKLinkAttributeName;
extern NSString *__RKAttachmentAttributeName;
extern NSString *__RKStrikethroughStyleAttributeName;
extern NSString *__RKStrikethroughColorAttributeName;
extern NSString *__RKShadowAttributeName;

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

#define RKFontAttributeName                     (__bridge NSString *)kCTFontAttributeName
#define RKBackgroundColorAttributeName          __RKBackgroundColorAttributeName
#define RKForegroundColorAttributeName          (__bridge NSString *)kCTForegroundColorAttributeName
#define RKUnderlineStyleAttributeName           (__bridge NSString *)kCTUnderlineStyleAttributeName
#define RKUnderlineColorAttributeName           (__bridge NSString *)kCTUnderlineColorAttributeName
#define RKStrikethroughStyleAttributeName       __RKStrikethroughStyleAttributeName
#define RKStrikethroughColorAttributeName       __RKStrikethroughColorAttributeName
#define RKStrokeColorAttributeName              (__bridge NSString *)kCTStrokeColorAttributeName
#define RKStrokeWidthAttributeName              (__bridge NSString *)kCTStrokeWidthAttributeName
#define RKLinkAttributeName                     __RKLinkAttributeName
#define RKAttachmentAttributeName               __RKAttachmentAttributeName
#define RKSuperscriptAttributeName              (__bridge NSString *)kCTSuperscriptAttributeName
#define RKParagraphStyleAttributeName           (__bridge NSString *)kCTParagraphStyleAttributeName
#define RKShadowAttributeName                   __RKShadowAttributeName

#define RKUnderlineStyleNone                    kCTUnderlineStyleNone
#define RKUnderlineStyleSingle                  kCTUnderlineStyleSingle
#define RKUnderlineStyleDouble                  kCTUnderlineStyleDouble
#define RKUnderlineStyleThick                   kCTUnderlineStyleThick

#define RKUnderlineByWordMask                   ((NSUInteger)0x1000)

#define RKUnderlinePatternDash                  kCTUnderlinePatternDash
#define RKUnderlinePatternDashDot               kCTUnderlinePatternDashDot
#define RKUnderlinePatternDashDotDot            kCTUnderlinePatternDashDotDot

#define RKAttachmentCharacter                   ((unichar)0xfffc)

#endif

