//
//  RKPDFLine.m
//  RTFKit
//
//  Created by Friedrich Gräter on 12.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFLine.h"

#import "RKPDFRenderingContext.h"
#import "RKPDFTextRenderer.h"
#import "RKPDFTextObject.h"
#import "RKParagraphStyleWrapper.h"
#import "RKPDFImage.h"

#import "NSAttributedString+PDFUtilities.h"

// An offset (NSNumber of NSInteger) describing the position displacement of a fully instantiated attributed string to its source
NSString *RKPDFLineInstantiationOffsetAttributeName			= @"RKPDFLineInstantiationOffset";

@interface RKPDFLine ()
{
	CTLineRef _line;
	NSAttributedString *_content;
}

@end

@implementation RKPDFLine

- (id)initWithAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidth:(CGFloat)width maximumHeight:(CGFloat)maximumHeight context:(RKPDFRenderingContext *)context
{
	self = [super init];
	
	if (self) {
		_context = context;
		
		[self setupWithAttributedString:attributedString inRange:range usingWidth:width maximumHeight:maximumHeight];
	}
	
	return self;
}

- (void)dealloc
{
	if (_line)
		CFRelease(_line);
}

- (void)setupWithAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidth:(CGFloat)width maximumHeight:(CGFloat)maximumHeight
{
	NSMutableAttributedString *lineContent = [[attributedString attributedSubstringFromRange: range] mutableCopy];
	__block NSInteger instantiationExtension = 0;
	
	// Treat all page breaks as line breaks to prevent layouting problems with CTTypesetter
	[lineContent.mutableString replaceOccurrencesOfString:@"\f" withString:@"\n" options:0 range:NSMakeRange(0, lineContent.length)];
	
	// Instantiate all text objects
	[lineContent enumerateAttribute:RKTextObjectAttributeName inRange:NSMakeRange(0, lineContent.length) options:0 usingBlock:^(RKPDFTextObject *textObject, NSRange range, BOOL *stop) {
		if (!textObject)
			return;
		
		NSAttributedString *replacementString = [textObject replacementStringUsingContext:_context attributedString:lineContent atIndex:range.location frameSize:CGSizeMake(width, maximumHeight)];
		if (!replacementString)
			return;

		// Apply replacement string
		[lineContent replaceCharactersInRange:range withAttributedString:replacementString];
		[lineContent addAttribute:RKTextObjectAttributeName value:textObject range: NSMakeRange(range.location, replacementString.length)];
		
		// Record offset displacement from this position
		instantiationExtension += (replacementString.length - range.length);
		[lineContent addAttribute:RKPDFLineInstantiationOffsetAttributeName value:@(instantiationExtension) range:NSMakeRange(range.location, lineContent.length - range.location)];
	}];
	
	// Apply hyphenation
	CTTypesetterRef typesetter = NULL;
	NSUInteger suggestedBreak = [self applyLineBreakToStringIfNeeded:lineContent width:(CGFloat)width usingTypesetter:&typesetter];
	
	// Layout the line
	CTLineRef ctLine = CTTypesetterCreateLine(typesetter, CFRangeMake(0, suggestedBreak));
	CFRelease(typesetter);
	
	// Get paragraph style
	CTParagraphStyleRef ctParagraphStyle = (__bridge CTParagraphStyleRef)[lineContent attribute:(__bridge NSString *)kCTParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	_paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle: ctParagraphStyle];
	_additionalParagraphStyle = [lineContent attribute:RKAdditionalParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	
	// Create a justified alignment if requested
	if ((_paragraphStyle.textAlignment == kCTJustifiedTextAlignment)) {
		NSUInteger breakPosition = range.location + suggestedBreak - 1;
		BOOL isEndOfString = (breakPosition+1 >= NSMaxRange(range));
		unichar lastCharacter = isEndOfString ? 0 : [attributedString.string characterAtIndex: breakPosition];
		
		if (!isEndOfString && (lastCharacter != '\n') && (lastCharacter != RKLineSeparatorCharacter || _additionalParagraphStyle.justifyLineBreaks)) {
			CTLineRef justifiedLine = CTLineCreateJustifiedLine(ctLine, 1.0, width);
			if (justifiedLine) {
				CFRelease(ctLine);
				ctLine = justifiedLine;
			}
			else
				NSLog(@"Cannot justify line for string: %@ on page %lu. Use unjustified variant.", lineContent.string, _context.currentPageNumber);
		}
	}

	// Determine preferred line height
	__block CGFloat maximumPreferredObjectHeight = 0;
	
	[lineContent enumerateAttribute:RKTextObjectAttributeName inRange:NSMakeRange(0, suggestedBreak) options:0 usingBlock:^(RKPDFTextObject *textObject, NSRange range, BOOL *stop) {
		if (textObject)
			maximumPreferredObjectHeight = MAX(maximumPreferredObjectHeight, [textObject preferredHeightForMaximumSize: CGSizeMake(width, maximumHeight)]);
	}];
	
	// Get original sting position displacement
	NSInteger displacement = [[lineContent attribute:RKPDFLineInstantiationOffsetAttributeName atIndex:(suggestedBreak - 1) effectiveRange:NULL] unsignedIntegerValue];
    
    // It has previously happened, that CoreText exposed some bugs where line breaks would be incorrectly computed. In this cases, it could happen that the line break happens before the end of the replacement, or the displacement length equals the suggested break. Ensure progress here by requiring at least one character to be consumed (which in fact is, as the footnote anchor is consumed).
    displacement = MIN(suggestedBreak - 1, displacement);
    
	// Setup line properties
	_line = ctLine;
	_content = lineContent;
	_visibleRange = NSMakeRange(range.location, suggestedBreak - displacement);
	_size = CTLineGetImageBounds(ctLine, _context.pdfContext).size;
	
	// Setup line metrics
	CGFloat ascent;
	CGFloat descent;
	CGFloat leading;
	
	_size.width = CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading);
	_ascent = MAX(ascent, maximumPreferredObjectHeight);

	// Round offsets to prevent scaling issues
	_ascent = round(_ascent / 0.5) * 0.5;
	_descent = round(descent / 0.5) * 0.5;
	_leading = round(leading / 0.5) * 0.5;
	
	_size.height = _ascent + _descent + _leading;
	
	NSAssert((_visibleRange.length <= attributedString.length) && (NSMaxRange(_visibleRange) <= attributedString.length), @"Invalid visible line range calculated: (%lu, %lu) from suggested line break: %lu, displacement: %lu for string: %@", _visibleRange.location, _visibleRange.length, suggestedBreak, displacement, attributedString);
}

- (NSUInteger)applyLineBreakToStringIfNeeded:(NSMutableAttributedString *)lineContent width:(CGFloat)width usingTypesetter:(CTTypesetterRef *)outTypesetter
{
	CTTypesetterRef currentTypesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)lineContent);
	NSUInteger suggestedBreak = CTTypesetterSuggestLineBreak(currentTypesetter, 0, width);

	// No line break needed
	if (suggestedBreak >= lineContent.length) {
		if (outTypesetter) *outTypesetter = currentTypesetter;
		return suggestedBreak;
	}
	
	// Unregister footnotes in truncated string
	[_context unregisterNotesInAttributedString:lineContent range:NSMakeRange(suggestedBreak, lineContent.length - suggestedBreak)];
	
	// Truncate the line
	NSMutableString *lineContentString = lineContent.mutableString;
	[lineContentString deleteCharactersInRange: NSMakeRange(suggestedBreak, lineContentString.length - suggestedBreak)];
		
	// If we truncated the line at a soft hyphen, try to add the hyphenation character. If this fails, try again with a shorter cut.
	NSUInteger hyphenPosition = suggestedBreak - 1;
		
	if ([lineContentString characterAtIndex: hyphenPosition] == RKSoftHyphenCharacter) {
		// Add hyphenation character
		NSString *hyphenationString = [lineContent attribute:RKHyphenationCharacterAttributeName atIndex:hyphenPosition effectiveRange:NULL];
		if (!hyphenationString)
			hyphenationString = @"-";
			
		[lineContentString replaceCharactersInRange:NSMakeRange(hyphenPosition, 1) withString:hyphenationString];
			
		CFRelease(currentTypesetter);
		return [self applyLineBreakToStringIfNeeded:lineContent width:width usingTypesetter:outTypesetter];
	}
	
	if (outTypesetter) *outTypesetter = currentTypesetter;
	return suggestedBreak;
}


- (void)renderUsingOrigin:(CGPoint)origin
{
	NSArray *lineRuns = (__bridge NSArray *)CTLineGetGlyphRuns(_line);
	CGContextRef pdfContext = self.context.pdfContext;
	
	CGContextSaveGState(pdfContext);
	CGContextTranslateCTM(pdfContext, origin.x, origin.y + _descent);
	CGContextSetTextMatrix(pdfContext, CGAffineTransformIdentity);
	
	// Draw line runs
	for (id runObject in lineRuns) {
		CTRunRef run = (__bridge CTRunRef)runObject;
		CFRange runRange = CTRunGetStringRange(run);
		CGRect boundingBox;

		// Apply base line offset, if required. We emulate baseline offset typesetting, since it is still not officially supported in CoreText, but there is undocumented support starting from macOS 10.12.
		CGFloat baselineOffset = [[self.content attribute:RKPDFRendererBaselineOffsetAttributeName atIndex:runRange.location effectiveRange:NULL] floatValue];
		if (baselineOffset) {
			CGContextTranslateCTM(pdfContext, 0, baselineOffset);
		}
		
		// Get text renderer and objects, if any
		NSArray *textRenderer = [self.content attribute:RKTextRendererAttributeName atIndex:runRange.location effectiveRange:NULL];
		RKPDFTextObject *textObject = [self.content attribute:RKTextObjectAttributeName atIndex:runRange.location effectiveRange:NULL];
		
		// Calculate bounding box, if required
		if (textObject || textRenderer)
			boundingBox = [self boundingBoxForRun:run range:runRange insideLine:_line withBoundingBox:CGRectMake(0, -_descent, _size.width, _size.height)];
		else
			boundingBox = CGRectMake(0, 0, 0, 0);
		
		// Apply pre-renderer
		if (textRenderer)
			[self applyTextRenderer:textRenderer forRun:run range:runRange boundingBox:boundingBox fromPriority:NSIntegerMin toPriority:0];
		
		// Render run
		CTRunDraw(run, pdfContext, CFRangeMake(0, 0));

		// Render, if text object
		if (textObject) {
			CGRect objectRect = boundingBox;
			objectRect.origin.y = boundingBox.origin.y + _descent;
			
			[textObject renderUsingContext:self.context rect:objectRect];
		}

		// Apply post-renderer
		if (textRenderer)
			[self applyTextRenderer:textRenderer forRun:run range:runRange boundingBox:boundingBox fromPriority:1 toPriority:NSIntegerMax];
		
		// Deactivate baseline offset
		if (baselineOffset)
			CGContextTranslateCTM(pdfContext, 0, -baselineOffset);		
	}
	
	CGContextRestoreGState(pdfContext);
}

- (void)applyTextRenderer:(NSArray *)sortedTextRenderer forRun:(CTRunRef)run range:(CFRange)range boundingBox:(CGRect)boundingBox fromPriority:(NSInteger)fromPriority toPriority:(NSInteger)toPriority
{
	for (Class renderer in sortedTextRenderer) {
		if ([renderer priority] > toPriority)
			return;
		
		if ([renderer priority] < fromPriority)
			continue;
		
		[renderer renderUsingContext:self.context attributedString:self.content range:NSMakeRange(range.location, range.length) run:run line:self boundingBox:boundingBox];
	}
}

- (CGRect)boundingBoxForRun:(CTRunRef)run range:(CFRange)runRange insideLine:(CTLineRef)line withBoundingBox:(CGRect)lineRect
{
    NSUInteger glyphCount = CTRunGetGlyphCount(run);
    CGSize glyphAdvances[glyphCount];
	CTRunGetAdvances(run, CFRangeMake(0, 0), glyphAdvances);
	
	CGFloat runWidth = 0;
    while (glyphCount --)
        runWidth += glyphAdvances[glyphCount].width;
	
    return CGRectMake(lineRect.origin.x + CTLineGetOffsetForStringIndex(line, runRange.location, NULL), lineRect.origin.y, runWidth, lineRect.size.height);
}


@end
