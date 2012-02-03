//
//  RKHeaderWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKHeaderWriter (TestExtensions)

+ (NSString *)fontTableFromResourceManager:(RKResourcePool *)resources;
+ (NSString *)colorTableFromResourceManager:(RKResourcePool *)resources;
+ (NSString *)listTableFromResourceManager:(RKResourcePool *)resources;
+ (NSString *)listOverrideTableFromResourceManager:(RKResourcePool *)resources;

+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document;
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;

@end


