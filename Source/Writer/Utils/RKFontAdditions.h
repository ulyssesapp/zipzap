//
//  RKFontAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Returns the default font for RTF documents
 */
CTFontRef RKGetDefaultFont(void);

#if !TARGET_OS_IPHONE
/*!
 @abstract NSFont extensions
 */
@interface NSFont (RTFFontAdditions)

/*!
 @abstract Provides the default for RTF documents (see RKGetDefaultFont)
 */
+ (NSFont *)RTFDefaultFont;

@end

#else

@interface UIFont (RTFFontAdditions)
/*!
 @abstract Provides the default for RTF documents (see RKGetDefaultFont)
 */
+ (UIFont *)RTFDefaultFont;

@end

#endif