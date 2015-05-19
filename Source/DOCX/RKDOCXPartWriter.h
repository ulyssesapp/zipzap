//
//  RKDOCXPartWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDOCXConversionContext;

/*!
 @abstract Specifies which subfolder string needs to be prepended to a filename.
 
 @const RKDOCXRootFolder		No subfolder, string won't be altered.
 @const RKDOCXRelsFolder		Prepends the string with "_rels/".
 @const RKDOCXDocPropsFolder	Prepends the string with "docProps/".
 @const RKDOCXWordFolder		Prepends the string with "word/".
 @const RKDOCXMediaFolder		Prepends the string with "media/".
 @const RKDOCXWordRelsFolder	Prepends the string with "word/_rels/".
 @const RKDOCXWordMediaFolder	Prepends the string with "word/media/".
 */
typedef enum : NSUInteger {
	RKDOCXRootFolder,
	RKDOCXRelsFolder,
	RKDOCXDocPropsFolder,
	RKDOCXWordFolder,
	RKDOCXMediaFolder,
	RKDOCXWordRelsFolder,
	RKDOCXWordMediaFolder,
} RKDOCXPackageFolder;

/*!
 @abstract Abstract superclass used by all writers creating XML document parts.
 */
@interface RKDOCXPartWriter : NSObject

/*!
 @abstract Returns an XML document with XML processing instruction and rootelement.
 */
+ (NSXMLDocument *)basicXMLDocumentWithRootElementName:(NSString *)root namespaces:(NSDictionary *)namespaces;

/*!
 @abstract Convenience method that returns an XML document with commonly used namespaces.
 @discussion All files with document text content use these namespaces.
 */
+ (NSXMLDocument *)basicXMLDocumentWithStandardNamespacesAndRootElementName:(NSString *)root;

/*!
 @abstract Returns a path inside the DOCX package for a file with the given name that should be stored inside the passed package folder.
 */
+ (NSString *)packagePathForFilename:(NSString *)filename folder:(RKDOCXPackageFolder)folder;

@end
