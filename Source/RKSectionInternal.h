//
//  RKSectionInternal.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKTypes.h"
#import "RKSection.h"

/*!
 @abstract Internal methods for testing purposes
 */
@interface RKSection ()

@property(nonatomic, strong, readonly) NSMapTable* headers;
@property(nonatomic, strong, readonly) NSMapTable* footers;

/*!
 @abstract Internally used to retrieve a text in a header/footer mapping for a given page type mask
 */
- (NSAttributedString *)frametextForPage:(RKPageSelectionMask)pageMask fromTextMap:(NSMapTable *)frametextMap;

/*!
 @abstract Internally used to set a text in a header/footer mapping for a given page type mask
 */
- (void)setFrametext:(NSAttributedString *)text forPages:(RKPageSelectionMask)pageMask toTextMap:(NSMapTable *)frametextMap;


@end
