//
//  RKPortableAttributeNames-MacOS.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if !TARGET_OS_IPHONE

/*!
 @abstract Macros used to abstract plattform specific constants
 */
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

#endif
