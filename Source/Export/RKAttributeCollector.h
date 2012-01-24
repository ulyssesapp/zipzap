//
//  RKDefinitionsCollector.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

@class RKDocument;

@interface RKAttributeCollector : NSObject

+(NSDictionary *)collectHeaderDefinitionsFromDocument:(RKDocument *)document;

@end
