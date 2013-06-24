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

- (id)initWithAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidth:(CGFloat)width maximumHeight:(CGFloat)maximumHeight justificationAllowed:(BOOL)justificationAllowed context:(RKPDFRenderingContext *)context
{
	self = [super init];
	
	if (self) {
		_context = context;
		
		[self setupWithAttributedString:attributedString inRange:range usingWidth:width maximumHeight:maximumHeight justificationAllowed:justificationAllowed];
	}
	
	return self;
}

- (void)setupWithAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidth:(CGFloat)width maximumHeight:(CGFloat)maximumHeight justificationAllowed:(BOOL)justificationAllowed
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
	
	// Estimate space for line wrap
	NSUInteger suggestedBreak = [self.class suggestLineBreakForAttributedString:lineContent usingWidth:width];
	
	// Should the line be wrapped?
	if (suggestedBreak < lineContent.length) {
		NSMutableString *lineContentString = lineContent.mutableString;

		// Truncate the line
		[lineContentString replaceCharactersInRange:NSMakeRange(suggestedBreak, lineContentString.length - suggestedBreak) withString:@""];
		
		// If we truncated the line at a soft hyphen, try to add the hyphenation character. If this fails, use a shorter cut
		NSUInteger hyphenPosition = suggestedBreak - 1;
		
		if ([lineContentString characterAtIndex: hyphenPosition] == RKSoftHyphenCharacter) {
			// Add hyphenation character
			NSString *hyphenationString = [lineContent attribute:RKHyphenationCharacterAttributeName atIndex:hyphenPosition effectiveRange:NULL];
			if (!hyphenationString)
				hyphenationString = @"-";
			
			[lineContentString replaceCharactersInRange:NSMakeRange(hyphenPosition, 1) withString:hyphenationString];
			
			// Try to layout the line again
			suggestedBreak = [self.class suggestLineBreakForAttributedString:lineContent usingWidth:width];
			hyphenPosition = suggestedBreak - 1;
			
			// Should we shorten the line after adding hyphenation?
			if (suggestedBreak < lineContent.length) {
				// Truncate the line again
				if (suggestedBreak < lineContent.length)
					[lineContentString replaceCharactersInRange:NSMakeRange(suggestedBreak, lineContentString.length - suggestedBreak) withString:@""];

				// Place hyphenation sign, if requested
				if ([lineContentString characterAtIndex: hyphenPosition] == RKSoftHyphenCharacter) {
					hyphenationString = [lineContent attribute:RKHyphenationCharacterAttributeName atIndex:hyphenPosition effectiveRange:NULL];
					if (!hyphenationString)
						hyphenationString = @"-";
					
					[lineContentString replaceCharactersInRange:NSMakeRange(hyphenPosition, 1) withString:hyphenationString];
				}
			}
		}
	}

	// Remove hyphenation attribute on line setting (fixes a weird CoreText bug if a line run contains an UTF-8 character like \u1D7BA)
	[lineContent removeAttribute:RKHyphenationCharacterAttributeName range:NSMakeRange(0, suggestedBreak)];
	
	// Layout the line
	CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)lineContent);
	CTLineRef ctLine = CTTypesetterCreateLine(typesetter, CFRangeMake(0, suggestedBreak));

	// Get paragraph style
	CTParagraphStyleRef ctParagraphStyle = (__bridge CTParagraphStyleRef)[lineContent attribute:(__bridge NSString *)kCTParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	_paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithCTParagraphStyle: ctParagraphStyle];
	_additionalParagraphStyle = [lineContent attribute:RKAdditionalParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
	
	// Create a justified alignment if requested
	if ((_paragraphStyle.textAlignment == kCTJustifiedTextAlignment) && (justificationAllowed)) {
		CTLineRef justifiedLine = CTLineCreateJustifiedLine(ctLine, 1.0, width);
		if (justifiedLine) {
			CFRelease(ctLine);
			ctLine = justifiedLine;
		}
 		else
			NSLog(@"Cannot justify line for string: %@ on page %lu. Use unjustified variant.", lineContent.string, _context.currentPageNumber);
	}

	// Get position displacement
	NSInteger displacement = [[lineContent attribute:RKPDFLineInstantiationOffsetAttributeName atIndex:(suggestedBreak - 1) effectiveRange:NULL] unsignedIntegerValue];
	
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
	_ascent = ascent;
	_descent = descent;
	_leading = leading;
	_size.height = _ascent + _descent + _leading;
}

+ (NSUInteger)suggestLineBreakForAttributedString:(NSAttributedString *)attributedString usingWidth:(CGFloat)width
{
	CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
	CFIndex suggestedBreak = CTTypesetterSuggestLineBreak(typesetter, 0, width);
	
	CFRelease(typesetter);
	
	return suggestedBreak;
}

- (void)dealloc
{
	if (_line)
		CFRelease(_line);
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

		// Apply base line offset, if required
		CGFloat baselineOffset = [[self.content attribute:RKBaselineOffsetAttributeName atIndex:runRange.location effectiveRange:NULL] floatValue];
		if (baselineOffset)
			CGContextTranslateCTM(pdfContext, 0, baselineOffset);
		
		// Get text renderer and objects, if any
		NSArray *textRenderer = [self.content attribute:RKTextRendererAttributeName atIndex:runRange.location effectiveRange:NULL];
		RKPDFTextObject *textObject = [self.content attribute:RKTextObjectAttributeName atIndex:runRange.location effectiveRange:NULL];
		
		// Calculate bounding box, if required
		if (textObject || textRenderer)
			boundingBox = [self boundingBoxForRun:run insideLine:_line withBoundingBox:CGRectMake(0, -_descent, _size.width, _size.height)];
		
		// Apply pre-renderer
		if (textRenderer)
			[self applyTextRenderer:textRenderer forRun:run range:runRange boundingBox:boundingBox fromPriority:NSIntegerMin toPriority:0];
		
		// Render run
		CTRunDraw(run, pdfContext, CFRangeMake(0, 0));

		// Render, if text object
		if (textObject)
			[textObject renderUsingContext:self.context rect:boundingBox];

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

- (CGRect)boundingBoxForRun:(CTRunRef)run insideLine:(CTLineRef)line withBoundingBox:(CGRect)lineRect
{
    const CGSize *glyphAdvances = CTRunGetAdvancesPtr(run);
    CGFloat runWidth = 0;
    NSUInteger glyphCount = CTRunGetGlyphCount(run);
	
    while (glyphCount --)
        runWidth += glyphAdvances[glyphCount].width;
	
    CFRange runRange = CTRunGetStringRange(run);
    CGRect runRect = CGRectMake(lineRect.origin.x + CTLineGetOffsetForStringIndex(line, runRange.location, NULL), lineRect.origin.y, runWidth, lineRect.size.height);
	
    return runRect;
}

@end
