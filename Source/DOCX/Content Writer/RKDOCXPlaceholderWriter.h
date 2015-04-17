//
//  RKDOCXPlaceholderWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@interface RKDOCXPlaceholderWriter : NSObject

+ (NSXMLElement *)placeholder:(NSNumber *)placeholder withRunElementName:(NSString *)runElementName textElementName:(NSString *)textElementName;

@end
