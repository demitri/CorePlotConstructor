//
//  CorePlotLineStyleViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CorePlotLineStyleViewController.h"
#import "IntegerSpaceFormatter.h"

@interface CPCDashPattern ()
@end

@implementation CPCDashPattern

- (id)initWithNumericArray:(NSArray*)array
{
	self = [super init];
	if (self) {
		self.numericArray = [array copy];
	}
	return self;
}

+ (CPCDashPattern*)dashPatternfromString:(NSString*)string
{
	if (string == nil || string.length == 0)
		return [[CPCDashPattern alloc] initWithNumericArray:[NSArray array]];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *s in [string componentsSeparatedByString:@" "])
		[array addObject:[NSDecimalNumber numberWithInt:[formatter numberFromString:s].intValue]];
	return [[CPCDashPattern alloc] initWithNumericArray:array];
}

- (NSString*)stringValue
{
	if (self.numericArray == nil)
		return @"";
	NSMutableArray *stringArray = [NSMutableArray array];
	for (NSNumber *n in self.numericArray)
		[stringArray addObject:n.stringValue];
	return [stringArray componentsJoinedByString:@" "];
}
@end

#pragma mark -

@interface CorePlotLineStyleViewController ()

@property (nonatomic, strong, readwrite) CPTLineStyle *currentLineStyle;

- (NSArray*)propertiesToObserve;

@end

@implementation CorePlotLineStyleViewController

/* Designated initializer */
- (id)init
{
	NSString *nibName = @"CorePlotLineStyleViewController";
	NSBundle *bundle = nil;
	self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        self.lineColor = [NSColor blackColor]; // can't be nil when nib loads
    }
    return self;
}

// -------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Disregard parameters - nib name is an implementation detail
	return [self init];
}

// -------------------------------------------------------------------
- (void)awakeFromNib
{
	// set up line cap popup button
	// ----------------------------
	[lineCapPopupButton removeAllItems];
	NSArray *lineCapOptions = @[@"Butt", @"Round", @"Square"];
	[lineCapPopupButton addItemsWithTitles:lineCapOptions];
	[lineCapPopupButton itemWithTitle:@"Butt"].tag = kCGLineCapButt;
	[lineCapPopupButton itemWithTitle:@"Round"].tag = kCGLineCapRound;
	[lineCapPopupButton itemWithTitle:@"Square"].tag = kCGLineCapSquare;
	
	// set up line join popup button
	// -----------------------------
	[lineJoinPopupButton removeAllItems];
	NSArray *lineJoinOptions = @[@"Miter", @"Round", @"Bevel"];
	[lineJoinPopupButton addItemsWithTitles:lineJoinOptions];
	[lineJoinPopupButton itemWithTitle:@"Miter"].tag = kCGLineJoinMiter;
	[lineJoinPopupButton itemWithTitle:@"Round"].tag = kCGLineJoinRound;
	[lineJoinPopupButton itemWithTitle:@"Bevel"].tag = kCGLineJoinBevel;
	
	dashPatternTextField.formatter = [[IntegerSpaceFormatter alloc] init];
	
	[self addObserver:self
		   forKeyPath:@"lineStyle"
			  options:NSKeyValueObservingOptionNew
			  context:nil];
	
	for (NSString *p in self.propertiesToObserve)
		[self addObserver:self
			   forKeyPath:p
				  options:NSKeyValueObservingOptionNew
				  context:nil];
}

- (NSArray*)propertiesToObserve
{
	return @[@"lineWidth", @"lineColor", @"miterLimit", @"dashPatternString", @"patternPhase"];
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"lineStyle"];
	
	for (NSString *p in self.propertiesToObserve)
		[self removeObserver:self forKeyPath:p];
}

- (void)updateWithLineStyle:(CPTLineStyle*)newLineStyle
{
	// update view with the properties of the newLineStyle
	self.lineWidth = newLineStyle.lineWidth;
	self.lineColor = newLineStyle.lineColor.nsColor;
	self.miterLimit = newLineStyle.miterLimit;
	self.dashPatternString = [newLineStyle.dashPattern copy];
	self.patternPhase = newLineStyle.patternPhase;

	if (newLineStyle.dashPattern == nil)
		self.dashPatternString = @"";
	else {
		CPCDashPattern *dashPattern = [[CPCDashPattern alloc] initWithNumericArray:newLineStyle.dashPattern];
		self.dashPatternString = dashPattern.stringValue;
	}
	[lineCapPopupButton selectItemWithTag:newLineStyle.lineCap];
	[lineJoinPopupButton selectItemWithTag:newLineStyle.lineJoin];
}

- (IBAction)popupMenuChanged:(id)sender
{
	self.currentLineStyle = [self lineStyleFromCurrentView];
}

- (CPTLineStyle*)currentLineStyle
{
	return [self lineStyleFromCurrentView];
}

- (CPTLineStyle*)lineStyleFromCurrentView
{
	// return a new CPTLineStyle based on the properties of the view.
	CPTMutableLineStyle *newLineStyle = [[CPTMutableLineStyle alloc] init];
	
	newLineStyle.lineWidth = self.lineWidth;
	newLineStyle.lineColor = [[CPTColor alloc] initWithCGColor:self.lineColor.CGColor];
	newLineStyle.miterLimit = self.miterLimit;

	newLineStyle.dashPattern = [CPCDashPattern dashPatternfromString:self.dashPatternString].numericArray;
	
	newLineStyle.patternPhase = self.patternPhase;
	newLineStyle.lineCap = (CGLineCap)lineCapPopupButton.selectedTag;
	newLineStyle.lineJoin = (CGLineJoin)lineJoinPopupButton.selectedTag;
	
	return newLineStyle;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@ changed", keyPath);
	if ([self.propertiesToObserve containsObject:keyPath])
		self.currentLineStyle = [self lineStyleFromCurrentView];
}


#pragma mark -
#pragma mark NSTextViewDelegate methods

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	//DLog(@"command: %@", NSStringFromSelector(command));
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number

		float delta = command == @selector(moveUp:) ? +1.0 : -1.0;
		
		BOOL handled = NO;
		
		switch (control.tag) {
				
			case TEXT_FIELD_LINE_WIDTH:
				// min value = 1
				if ((delta > 0 && self.lineWidth > 0) || (delta < 0 && self.lineWidth > 1))
					self.lineWidth += delta;
				handled = YES;
				break;
				
			case TEXT_FIELD_MITER_LIMIT:
				// min value = 1
				if ((delta > 0 && self.miterLimit > 0) || (delta < 0 && self.miterLimit > 1))
					self.miterLimit += delta;
				handled = YES;
				break;
				
			case TEXT_FIELD_PHASE:
				// min value = 0
				if (self.patternPhase + delta < 0)
					self.patternPhase = 0.0;
				else
					self.patternPhase += delta;
//				if ((delta > 0 && self.patternPhase > 0) || (delta < 0 && self.patternPhase > 1))
//					self.patternPhase += delta;
				handled = YES;
				break;
		}
		if (handled)
			return YES;
		
		return NO;
	}
	
	return NO;
}

@end
