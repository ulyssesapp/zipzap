//
//  RKDOCXLinkWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXRunWriter.h"

// Keys
extern NSString *RKDOCXFieldLinkFirstPartKey;
extern NSString *RKDOCXFieldLinkLastPartKey;

/*!
 @abstract Converter for link run elements.
 */
@interface RKDOCXLinkWriter : NSObject

/*!
 @abstract Converts the passed link attachment to an array containing either a single hyperlink element or all run elements including field hyperlink runs. If the linkAttribute is nil the method returns the passed runElements array.
 @discussion linkAttribute must be either of type NSURL or NSString.
 */
+ (NSArray *)runElementsForLinkAttribute:(id)linkAttribute runType:(RKDOCXRunType)runType runElements:(NSArray *)runElements usingContext:(RKDOCXConversionContext *)context;

@end
