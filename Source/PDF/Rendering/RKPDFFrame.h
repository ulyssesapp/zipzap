//
//  RKPDFFrame.h
//  RTFKit
//
//  Created by Friedrich Gräter on 12.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriterTypes.h"

@class RKPDFRenderingContext, RKPDFLine;

/*!
 @abstract Specifies the growing direction of a frame
 @const
	RKPDFFrameGrowingDownwards			The frame grows from top to bottom
	RKPDFFrameGrowingUpwards			The frame grows from bottom to top
 */
typedef enum : NSUInteger {
	RKPDFFrameGrowingDownwards		= 0,
	RKPDFFrameGrowingUpwards		= 1
}RKPDFFrameGrowingDirection;

@interface RKPDFFrame : NSObject

/*!
 @abstract Initializes a frame with a bounding box, a growing direction and a context
 */
- (id)initWithRect:(CGRect)boundingBox growingDirection:(RKPDFFrameGrowingDirection)growingDirection context:(RKPDFRenderingContext *)context;

/*!
 @abstract Appends all lines of the given attributed string (in core text representation)
 @discussion After layouting a line, the given block is called with the string range of the line. If a widowWidth (the width of the first line in a succeeding frame) is given, the block gets informed if the next line of a paragraph will result to a widow if the column would terminate after the current line. The block is allowed to remove lines during its execution. All text objects in the attributed string will be instantiated by the method. If specified, the first line of the frame will be layed out even though it has not enough space. This should be done on first lines of a column, if no other contents have been layed out to prevent infinite loops. 
 */
- (void)appendAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range enforceFirstLine:(BOOL)enforceFirstLine usingWidowWidth:(CGFloat)widowWidth block:(void(^)(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop))block;

/*!
 @abstract Removes one or multiple lines from the end of the frame
 */
- (void)removeLinesFromEnd:(NSUInteger)lineCount;

/*!
 @abstract Passes a line object with a certain index
 */
- (RKPDFLine *)lineAtIndex:(NSUInteger)lineIndex;

/*!
 @abstract Passes the last line of the frame
 */
- (RKPDFLine *)lastLine;

/*!
 @abstract Tests, whether the frame can be extended by a line with the given height without hurting its maxium height constraint
 */
- (BOOL)canAppendLineWithHeight:(CGFloat)expectedLineHeight;

/*!
 @abstract The rect of the frame
 */
@property (nonatomic, readonly) CGRect boundingBox;

/*!
 @abstract The visible rect of the frame
 */
@property (nonatomic, readonly) CGRect visibleBoundingBox;

/*!
 @abstract The length of the visible string
 */
@property (nonatomic, readonly) NSUInteger visibleStringLength;

/*!
 @abstract The lines of the frame (array of RKPDFLine*)
 */
@property (nonatomic, readonly) NSArray *lines;

/*!
 @abstract Specifies the maximum height the frame might reach (initialized to the bounding box of the frame)
 @discussion Might be set after initialization. However this property will be only considered when adding further lines to the frame.
 */
@property (nonatomic, readwrite) CGFloat maximumHeight;

/*!
 @abstract The growing direction of the frame
 */
@property (nonatomic, readonly) RKPDFFrameGrowingDirection growingDirection;

/*!
 @abstract Renders a frane to its graphics context within the given rect.
 */
- (void)renderUsingOptions:(RKPDFWriterRenderingOptions)options;

@end
