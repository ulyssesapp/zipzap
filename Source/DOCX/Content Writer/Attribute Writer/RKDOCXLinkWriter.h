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

/*!
 @abstract Converts the passed link attachment to a hyperlink element.
 @discussion linkAttribute must be either of type NSURL or NSString.
 */
+ (NSXMLElement *)linkElementForAttribute:(id)linkAttribute usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns a dictionary containing all runs requiered for field hyperlinks.
 @discussion The dictionary contains two entries, one is an array filled with runs preceeding the actual link run, the other one is the element succeeding the link run.
 */
+ (NSDictionary *)fieldHyperlinkRunElementsForLinkAttribute:(id)linkAttribute runType:(RKDOCXRunType)runType usingContext:(RKDOCXConversionContext *)context;

@end
