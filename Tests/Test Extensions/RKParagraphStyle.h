//
//  RKParagraphStyle.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if !TARGET_OS_IPHONE

#define RKLeftTextAlignment             RKTextAlignmentLeft
#define RKCenterTextAlignment           RKTextAlignmentCenter
#define RKRightTextAlignment            RKTextAlignmentRight
#define RKJustifiedTextAlignment        RKTextAlignmentJustified
#define RKNaturalTextAlignment          NSNaturalTextAlignment

#define RKWritingDirectionNatural       NSWritingDirectionNatural
#define RKWritingDirectionLeftToRight   NSWritingDirectionLeftToRight
#define RKWritingDirectionRightToLeft   NSWritingDirectionRightToLeft

#else

#define RKLeftTextAlignment             kCTLeftTextAlignment
#define RKCenterTextAlignment           kCTCenterTextAlignment
#define RKRightTextAlignment            kCTRightTextAlignment
#define RKJustifiedTextAlignment        kCTJustifiedTextAlignment
#define RKNaturalTextAlignment          kCTNaturalTextAlignment

#define RKWritingDirectionNatural       kCTWritingDirectionNatural
#define RKWritingDirectionLeftToRight   kCTWritingDirectionLeftToRight
#define RKWritingDirectionRightToLeft   kCTWritingDirectionRightToLeft

#endif


/*!
 @abstract Provides a replacement for NSParagraphStyle
 */
@interface RKParagraphStyle : NSObject

@property (nonatomic) NSUInteger alignment;
@property (nonatomic) CGFloat firstLineHeadIndent;
@property (nonatomic) CGFloat headIndent;
@property (nonatomic) CGFloat tailIndent;
@property (nonatomic, strong, readwrite) NSArray *tabStops;
@property (nonatomic) CGFloat defaultTabInterval;
@property (nonatomic) CGFloat lineHeightMultiple;
@property (nonatomic) CGFloat maximumLineHeight;
@property (nonatomic) CGFloat minimumLineHeight;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat paragraphSpacing;
@property (nonatomic) CGFloat paragraphSpacingBefore;
@property (nonatomic) NSUInteger baseWritingDirection;

+ (RKParagraphStyle *)paragraphStyleFromCoreTextRepresentation:(CTParagraphStyleRef)paragraphStyle;

- (CTParagraphStyleRef)coreTextRepresentation;

+ (RKParagraphStyle *)paragraphStyleFromTargetSpecificRepresentation:(id)paragraphStyle;

- (id)targetSpecificRepresentation;

@end
