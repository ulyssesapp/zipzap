//
//  RKPDFLine.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFLine.h"

@implementation RKPDFLine

- (id)initWithBoundingBox:(CGRect)boundingBox ascent:(CGFloat)ascent descent:(CGFloat)descent leading:(CGFloat)leading range:(NSRange)range
{
    self = [super init];
    
    if (self) {
        _boundingBoxWithoutDescent = boundingBox;
        _boundingBox = boundingBox;

        _boundingBox.origin.y -= descent;
        _boundingBox.size.height += descent;
        
        _ascent = ascent;
        _descent = descent;
        _leading = leading;

        _range = range;
    }
    
    return self;
}

@end
