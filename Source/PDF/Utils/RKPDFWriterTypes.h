//
//  RKPDFWriterTypes.h
//  RTFKit
//
//  Created by Friedrich Gräter on 18.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Rendering options for PDF output
 @const
 RKPDFWriterShowVisibleFrameBounds			Adds bounding boxes around the actually rendered text frames (intended for debugging layout settings)
 RKPDFWriterShowMaximumFrameBounds           Adds text frames around text frames (intended for debugging layout settings)
 */
typedef enum : NSUInteger {
    RKPDFWriterShowVisibleFrameBounds		= (1 << 0),
    RKPDFWriterShowMaximumFrameBounds       = (1 << 1),
}RKPDFWriterRenderingOptions;
