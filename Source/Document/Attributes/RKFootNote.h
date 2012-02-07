//
//  RKFootnote.h
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKFootnoteAttributeName;

@interface RKFootnote : NSObject

/*!
 @abstract Creates a new foot note using an attributed string
 */
+ (RKFootnote *)footnoteWithAttributedString:(NSAttributedString *)content;

/*!
 @abstract Initializes a foot note using an attributed string
 */
- (id)initWithAttributedString:(NSAttributedString *)content;

/*!
 @abstract The content of the foot note
 */
@property (nonatomic,readwrite,strong) NSAttributedString *content;

/*!
 @abstract Footnote or Endnote ?
 */
@property (nonatomic) BOOL isEndnote;

@end
