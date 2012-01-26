//
//  RKSectionTest.h
//  RTFKit
//
//  Created by Friedrich Gräter on 20.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

@interface RKSectionTest : SenTestCase

@end

@interface RKSection ()
    - (NSAttributedString *)objectForPage:(RKPageSelectionMask)pageMask fromMap:(NSMapTable *)map;
    - (void)setObject:(NSAttributedString *)object forPages:(RKPageSelectionMask)pageMask toMap:(NSMapTable *)map;
@end