//
//  ZZTestUtil.h
//  ZipZap
//
//  Created by Glen Low on 19/10/12.
//  Copyright (c) 2012, Pixelglow Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTasks : NSObject

// The bundle that holds the test resources (the SwiftPM resource bundle).
+ (NSBundle*)resourceBundle;
// The list of test asset file names (formerly the ZZTestFiles Info.plist key).
+ (NSArray*)testFiles;

+ (void)zipFiles:(NSArray*)filePaths toPath:(NSString*)zipPath;
+ (BOOL)testZipAtPath:(NSString*)path;
+ (NSData*)unzipFile:(NSString*)filePath fromPath:(NSString*)zipPath;
+ (NSArray*)zipInfoAtPath:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
