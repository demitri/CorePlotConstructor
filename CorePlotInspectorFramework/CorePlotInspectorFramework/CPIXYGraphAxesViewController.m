//
//  CPIXYGraphAxesViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CPIXYGraphAxesViewController.h"
#import "CPIPrivateHeader.h"


@interface CPIXYGraphAxesViewController ()
@end

#pragma mark -

@implementation CPIXYGraphAxesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Ref: http://stackoverflow.com/questions/12557936/loading-a-nib-thats-included-in-a-framework
	NSString *frameworkBundleID = FRAMEWORK_BUNDLE_ID;
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];

    self = [super initWithNibName:@"CPIXYGraphAxesView" bundle:frameworkBundle];
    if (self) {
		[self commonInit];
    }
    return self;
}

- (void)commonInit
{
	[super commonInit];
	self.title = @"XYGraph Axes";
	self.lineStyleViewController = nil; //[[CorePlotLineStyleViewController alloc] init];
}

- (void)awakeFromNib
{
	if (xibInitialized)
		return;
	
	NSArray *cptSignLabels = @[@"No Offset", @"Positive Offset", @"Negative Offset"];
	for (NSPopUpButton *popup in @[tickDirectionXPopupButton, tickDirectionYPopupButton]) {
		[popup removeAllItems];
		[popup addItemsWithTitles:cptSignLabels];
		[popup itemWithTitle:@"No Offset"].tag = CPTSignNone;
		[popup itemWithTitle:@"Positive Offset"].tag = CPTSignPositive;
		[popup itemWithTitle:@"Negative Offset"].tag = CPTSignNegative;
	}

}

- (CPTXYAxis*)xAxis
{
	return ((CPTXYAxisSet *)self.graph.axisSet).xAxis;
}

- (CPTXYAxis*)yAxis
{
	return ((CPTXYAxisSet *)self.graph.axisSet).yAxis;
}

// Used as a value for binding.
- (NSNumber*)zeroValue { return @0; }

- (IBAction)editLineStyle:(id)sender
{
	if (self.lineStyleViewController != nil) {
		// This will happen when trying to open a new popup before the old one is closed.
		// Need to clean up the key/value observing before this happens.
		[self.lineStyleViewController removeObserver:self forKeyPath:@"currentLineStyle"];
	}
	
	self.lineStyleBeingEdited = [sender tag];
	
	CPTLineStyle *lineStyleToEdit = nil;
	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_X_AXIS:
			lineStyleToEdit = self.xAxis.axisLineStyle;
			break;
		case EDIT_LINE_STYLE_Y_AXIS:
			lineStyleToEdit = self.yAxis.axisLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_X:
			lineStyleToEdit = self.xAxis.majorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_Y:
			lineStyleToEdit = self.yAxis.majorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_X:
			lineStyleToEdit = self.xAxis.minorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_Y:
			lineStyleToEdit = self.yAxis.minorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_X:
			lineStyleToEdit = self.xAxis.majorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_Y:
			lineStyleToEdit = self.yAxis.majorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_X:
			lineStyleToEdit = self.xAxis.minorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_Y:
			lineStyleToEdit = self.yAxis.minorTickLineStyle;
			break;
	}
	
	// create the popover
	self.lineStylePopover = [[NSPopover alloc] init];
	
	self.lineStyleViewController = [[CPILineStyleViewController alloc] init];
	[self.lineStyleViewController updateWithLineStyle:lineStyleToEdit];
	
	self.lineStylePopover.contentViewController = self.lineStyleViewController;
	self.lineStylePopover.behavior = NSPopoverBehaviorTransient;
	self.lineStylePopover.delegate = self;

	[self.lineStyleViewController addObserver:self
								   forKeyPath:@"currentLineStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];

	NSButton *targetButton = (NSButton *)sender;
	[self.lineStylePopover showRelativeToRect:targetButton.bounds
									   ofView:sender
								preferredEdge:NSMinYEdge]; // display on top of button
}


#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	CPTLineStyle *newLineStyle = self.lineStyleViewController.currentLineStyle;
	
	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_X_AXIS:
			self.xAxis.axisLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_Y_AXIS:
			self.yAxis.axisLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_X:
			self.xAxis.majorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_Y:
			self.yAxis.majorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_X:
			self.xAxis.minorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_Y:
			self.xAxis.minorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_X:
			self.xAxis.majorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_Y:
			self.yAxis.majorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_X:
			self.xAxis.minorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_Y:
			self.yAxis.minorTickLineStyle = newLineStyle;
			break;
	}
	
	[self.lineStyleViewController removeObserver:self forKeyPath:@"currentLineStyle"];
	self.lineStylePopover = nil;
	self.lineStyleViewController = nil;
	//self.axisBeingEdited = nil;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self.lineStyleViewController) {
		if ([keyPath isEqualToString:@"currentLineStyle"]) {
			switch (self.lineStyleBeingEdited) {
				case EDIT_LINE_STYLE_X_AXIS:
					self.xAxis.axisLineStyle = self.lineStyleViewController.currentLineStyle;
					break;
				case EDIT_LINE_STYLE_Y_AXIS:
					self.yAxis.axisLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_GRID_X:
					self.xAxis.majorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_GRID_Y:
					self.yAxis.majorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_GRID_X:
					self.xAxis.minorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_GRID_Y:
					self.xAxis.minorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_TICK_X:
					self.xAxis.majorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_TICK_Y:
					self.yAxis.majorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_TICK_X:
					self.xAxis.minorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_TICK_Y:
					self.yAxis.minorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
			}

		}
	}
}

#pragma mark -
#pragma mark NSTextViewDelegate methods

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number
		
		float delta = command == @selector(moveUp:) ? +1 : -1;
		
		BOOL handled = NO;
		
		switch (control.tag) {
				
			case MAJOR_TICK_LENGTH_X:
				if (delta < 0 && self.xAxis.majorTickLength <= 1)
					self.xAxis.majorTickLength = 0;
				else
					self.xAxis.majorTickLength += delta;
				handled = YES;
				break;
			case MAJOR_TICK_LENGTH_Y:
				if (delta < 0 && self.yAxis.majorTickLength <= 1)
					self.yAxis.majorTickLength = 0;
				else
					self.yAxis.majorTickLength += delta;
				handled = YES;
				break;
			case MINOR_TICK_LENGTH_X:
				if (delta < 0 && self.xAxis.minorTickLength <= 1)
					self.xAxis.minorTickLength = 0;
				else
					self.xAxis.minorTickLength += delta;
				handled = YES;
				break;
			case MINOR_TICK_LENGTH_Y:
				if (delta < 0 && self.yAxis.minorTickLength <= 1)
					self.yAxis.minorTickLength = 0;
				else
					self.yAxis.minorTickLength += delta;
				handled = YES;
				break;
			case MINOR_TICKS_PER_INTERVAL_X:
				if (delta < 0 && self.xAxis.minorTicksPerInterval <= 1)
					self.xAxis.minorTicksPerInterval = 0;
				else
					self.xAxis.minorTicksPerInterval += delta;
				handled = YES;
				break;
			case MINOR_TICKS_PER_INTERVAL_Y:
				if (delta < 0 && self.yAxis.minorTicksPerInterval <= 1)
					self.yAxis.minorTicksPerInterval = 0;
				else
					self.yAxis.minorTicksPerInterval += delta;
				handled = YES;
				break;
			case MINOR_TICK_LABEL_OFFSET_X:
				if (delta < 0 && self.xAxis.minorTickLabelOffset <= 1)
					self.xAxis.minorTickLabelOffset = 0;
				else
					self.xAxis.minorTickLabelOffset += delta;
				break;
			case MINOR_TICK_LABEL_OFFSET_Y:
				if (delta < 0 && self.yAxis.minorTickLabelOffset <= 1)
					self.yAxis.minorTickLabelOffset = 0;
				else
					self.yAxis.minorTickLabelOffset += delta;
			case PREF_NO_MAJOR_TICKS_X:
				if (delta < 0 && self.xAxis.preferredNumberOfMajorTicks <= 1)
					self.xAxis.preferredNumberOfMajorTicks = 0;
				else
					self.xAxis.preferredNumberOfMajorTicks += delta;
				handled = YES;
				break;
			case PREF_NO_MAJOR_TICKS_Y:
				if (delta < 0 && self.yAxis.preferredNumberOfMajorTicks <= 1)
					self.yAxis.preferredNumberOfMajorTicks = 0;
				else
					self.yAxis.preferredNumberOfMajorTicks += delta;
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
