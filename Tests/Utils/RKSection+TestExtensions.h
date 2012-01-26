//
//  RKSection+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKSection (TestExtensions)
- (NSAttributedString *)objectForPage:(RKPageSelectionMask)pageMask fromMap:(NSMapTable *)map;
- (void)setObject:(NSAttributedString *)object forPages:(RKPageSelectionMask)pageMask toMap:(NSMapTable *)map;
@end

