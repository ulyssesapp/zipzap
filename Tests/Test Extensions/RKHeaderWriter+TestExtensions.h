//
//  RKHeaderWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKHeaderWriter (TestExtensions)

+ (NSString *)fontTableFromResourcePool:(RKResourcePool *)resources;
+ (NSString *)colorTableFromResourcePool:(RKResourcePool *)resources;
+ (NSString *)styleSheetsFromResourcePool:(RKResourcePool *)resources;
+ (NSString *)listTableFromResourcePool:(RKResourcePool *)resources;
+ (NSString *)listOverrideTableFromResourcePool:(RKResourcePool *)resources;

+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document;
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;

@end


