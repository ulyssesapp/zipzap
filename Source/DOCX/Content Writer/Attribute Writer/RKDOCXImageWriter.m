//
//  RKDOCXImageWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXImageWriter.h"

#import "RKConversion.h"
#import "RKImage.h"
#import "RKDOCXPartWriter.h"
#import "RKDOCXRunWriter.h"

#import "NSXMLElement+IntegerValueConvenience.h"

#if TARGET_OS_IPHONE
	#import <MobileCoreServices/MobileCoreServices.h>
#endif

// Elements
NSString *RKDOCXImageAdjustValueListElementName		= @"a:avLst";
NSString *RKDOCXImageBlipElementName				= @"a:blip";
NSString *RKDOCXImageBlipFillElementName			= @"pic:blipFill";
NSString *RKDOCXImageDocumentPropertiesElementName	= @"wp:docPr";
NSString *RKDOCXImageDrawingElementName				= @"w:drawing";
NSString *RKDOCXImageExtentElementName				= @"wp:extent";
NSString *RKDOCXImageFillRectElementName			= @"a:fillRect";
NSString *RKDOCXImageGraphicDataElementName			= @"a:graphicData";
NSString *RKDOCXImageGraphicElementName				= @"a:graphic";
NSString *RKDOCXImageInlineElementName				= @"wp:inline";
NSString *RKDOCXImageNonVisualCanvasElementName		= @"pic:cNvPr";
NSString *RKDOCXImageNonVisualPropertiesElementName	= @"pic:nvPicPr";
NSString *RKDOCXImagePicElementName					= @"pic:pic";
NSString *RKDOCXImagePresetGeometryElementName		= @"a:prstGeom";
NSString *RKDOCXImageShapePropertiesElementName		= @"pic:spPr";
NSString *RKDOCXImageStretchElementName				= @"a:stretch";
NSString *RKDOCXImageTransformElementName			= @"a:xfrm";
NSString *RKDOCXImageTransformExtentElementName		= @"a:ext";
NSString *RKDOCXImageTransformOffElementName		= @"a:off";

// Attributes
NSString *RKDOCXImageBottomMarginAttributeName		= @"distB";
NSString *RKDOCXImageCanvasXAttributeName			= @"cx";
NSString *RKDOCXImageCanvasYAttributeName			= @"cy";
NSString *RKDOCXImageDescriptionAttributeName		= @"descr";
NSString *RKDOCXImageEmbedAttributeName				= @"r:embed";
NSString *RKDOCXImageGraphicDataAttributeName		= @"uri";
NSString *RKDOCXImageIdentifierAttributeName		= @"id";
NSString *RKDOCXImageLeftMarginAttributeName		= @"distL";
NSString *RKDOCXImageMainNamespace					= @"xmlns:a";
NSString *RKDOCXImageMainNamespaceURL				= @"http://schemas.openxmlformats.org/drawingml/2006/main";
NSString *RKDOCXImageNameAttributeName				= @"name";
NSString *RKDOCXImagePictureNamespace				= @"xmlns:pic";
NSString *RKDOCXImagePictureNamespaceURL			= @"http://schemas.openxmlformats.org/drawingml/2006/picture";
NSString *RKDOCXImagePresetGeometryAttributeName	= @"prst";
NSString *RKDOCXImageRightMarginAttributeName		= @"distR";
NSString *RKDOCXImageTopMarginAttributeName			= @"distT";

// Other
NSString *RKDOCXImageRelationshipType				= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/image";

@implementation RKDOCXImageWriter

+ (NSXMLElement *)runElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKImageAttachment *imageAttachment = attributes[RKImageAttachmentAttributeName];
	
	if (!imageAttachment)
		return nil;
	
	RKImage *image = [[RKImage alloc] initWithData: imageAttachment.imageFile.regularFileContents];
	
	// Relationship Handling
	NSString *filename = [RKDOCXPartWriter packagePathForFilename:[imageAttachment.imageFile.preferredFilename sanitizedFilenameForRTFD] folder:RKDOCXMediaFolder];
	
	// Word does not support spaces in filenames.
	filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
	
	[context addDocumentPartWithData:imageAttachment.imageFile.regularFileContents filename:[RKDOCXPartWriter packagePathForFilename:filename folder:RKDOCXWordFolder] MIMEType:[self preferredMIMETypeForPathExtension: imageAttachment.imageFile.preferredFilename.pathExtension]];
	NSString *identifier = [context newImageId];
	NSString *relationshipID = [NSString stringWithFormat: @"rId%lu", [context indexForRelationshipWithTarget:filename andType:RKDOCXImageRelationshipType]];
	NSXMLElement *blipElement = [NSXMLElement elementWithName:RKDOCXImageBlipElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXImageEmbedAttributeName stringValue:relationshipID]]];
	NSArray *nonVisualPropertyAttributes = @[[NSXMLElement attributeWithName:RKDOCXImageIdentifierAttributeName stringValue:identifier], [NSXMLElement attributeWithName:RKDOCXImageNameAttributeName stringValue:imageAttachment.imageFile.preferredFilename]];
	NSArray *documentPropertyAttributes = @[[NSXMLElement attributeWithName:RKDOCXImageIdentifierAttributeName stringValue:identifier],
											[NSXMLElement attributeWithName:RKDOCXImageNameAttributeName stringValue:imageAttachment.imageFile.preferredFilename],
											[NSXMLElement attributeWithName:RKDOCXImageDescriptionAttributeName stringValue:@""]];
	
	// Image Margins
	NSArray *margins = @[[NSXMLElement attributeWithName:RKDOCXImageTopMarginAttributeName integerValue:RKPointsToEMUs(imageAttachment.margin.top)],
						 [NSXMLElement attributeWithName:RKDOCXImageLeftMarginAttributeName integerValue:RKPointsToEMUs(imageAttachment.margin.left)],
						 [NSXMLElement attributeWithName:RKDOCXImageRightMarginAttributeName integerValue:RKPointsToEMUs(imageAttachment.margin.right)],
						 [NSXMLElement attributeWithName:RKDOCXImageBottomMarginAttributeName integerValue:RKPointsToEMUs(imageAttachment.margin.bottom)]];
	
	// Image Size
	NSSize scaledImageSize = [self scaledImageSizeForImage:image usingContext:context];
	NSInteger width = RKPointsToEMUs(scaledImageSize.width);
	NSInteger height = RKPointsToEMUs(scaledImageSize.height);
	NSXMLElement *extentElement = [NSXMLElement elementWithName:RKDOCXImageExtentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXImageCanvasXAttributeName integerValue:width],
																													   [NSXMLElement attributeWithName:RKDOCXImageCanvasYAttributeName integerValue:height]]];
	NSXMLElement *transformExtentElement = [NSXMLElement elementWithName:RKDOCXImageTransformExtentElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXImageCanvasXAttributeName integerValue:width],
																																		 [NSXMLElement attributeWithName:RKDOCXImageCanvasYAttributeName integerValue:height]]];
	
	// Boilerplate XML Tree
	NSXMLElement *presetGeometryElement = [NSXMLElement elementWithName:RKDOCXImagePresetGeometryElementName children:@[[NSXMLElement elementWithName: RKDOCXImageAdjustValueListElementName]] attributes:@[[NSXMLElement attributeWithName:RKDOCXImagePresetGeometryAttributeName stringValue:@"rect"]]];
	NSXMLElement *transformElement = [NSXMLElement elementWithName:RKDOCXImageTransformElementName children:@[[NSXMLElement elementWithName:RKDOCXImageTransformOffElementName children:nil attributes:@[[NSXMLElement attributeWithName:@"x" stringValue:@"0"], [NSXMLElement attributeWithName:@"y" stringValue:@"0"]]], transformExtentElement] attributes:nil];
	NSXMLElement *shapePropertiesElement = [NSXMLElement elementWithName:RKDOCXImageShapePropertiesElementName children:@[transformElement, presetGeometryElement] attributes:nil];
	NSXMLElement *stretchElement = [NSXMLElement elementWithName:RKDOCXImageStretchElementName children:@[[NSXMLElement elementWithName: RKDOCXImageFillRectElementName]] attributes:nil];
	NSXMLElement *blipFillElement = [NSXMLElement elementWithName:RKDOCXImageBlipFillElementName children:@[blipElement, stretchElement] attributes:nil];
	NSXMLElement *nonVisualPropertiesElement = [NSXMLElement elementWithName:RKDOCXImageNonVisualPropertiesElementName children:@[[NSXMLElement elementWithName:RKDOCXImageNonVisualCanvasElementName children:nil attributes:nonVisualPropertyAttributes], [NSXMLElement elementWithName: @"pic:cNvPicPr"]] attributes:nil];
	NSXMLElement *picElement = [NSXMLElement elementWithName:RKDOCXImagePicElementName children:@[nonVisualPropertiesElement, blipFillElement, shapePropertiesElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXImagePictureNamespace stringValue:RKDOCXImagePictureNamespaceURL]]];
	NSXMLElement *graphicDataElement = [NSXMLElement elementWithName:RKDOCXImageGraphicDataElementName children:@[picElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXImageGraphicDataAttributeName stringValue:RKDOCXImagePictureNamespaceURL]]];
	NSXMLElement *graphicElement = [NSXMLElement elementWithName:RKDOCXImageGraphicElementName children:@[graphicDataElement] attributes:@[[NSXMLElement attributeWithName:RKDOCXImageMainNamespace stringValue:RKDOCXImageMainNamespaceURL]]];
	NSXMLElement *documentPropertiesElement = [NSXMLElement elementWithName:RKDOCXImageDocumentPropertiesElementName children:nil attributes:documentPropertyAttributes];
	// Margins are not part of the boilerplate!
	NSXMLElement *inlineElement = [NSXMLElement elementWithName:RKDOCXImageInlineElementName children:@[extentElement, documentPropertiesElement, graphicElement] attributes:margins];
	NSXMLElement *drawingElement = [NSXMLElement elementWithName:RKDOCXImageDrawingElementName children:@[inlineElement] attributes:nil];

	return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:drawingElement usingContext:context];
}

+ (NSString *)preferredMIMETypeForPathExtension:(NSString *)pathExtension
{
	// Get type identifier
	NSString *typeIdentifier = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pathExtension, NULL);
	
	// Get MIME type for type identifier
	return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)typeIdentifier, kUTTagClassMIMEType);
}

+ (NSSize)scaledImageSizeForImage:(RKImage *)image usingContext:(RKDOCXConversionContext *)context
{
	NSSize scaledImageSize = image.size;
	
	CGFloat aspect = scaledImageSize.width / (context.document.pageSize.width - (context.document.pageInsets.inner + context.document.pageInsets.outer));
	
	if (aspect > 1) {
		scaledImageSize.width /= aspect;
		scaledImageSize.height /= aspect;
	}
	
	return scaledImageSize;
}

@end
