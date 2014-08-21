//
//  XYGraphAxesViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "XYGraphAxesViewController.h"

@interface XYGraphAxesViewController ()

@end

#pragma mark -

@implementation XYGraphAxesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		self.lineStyleViewController = [[CorePlotLineStyleViewController alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)dealloc
{
}

- (CPTGraph*)graph
{
	return mc.graph;
}

- (CPTXYAxis*)xAxis
{
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
	return axisSet.xAxis;
}

- (CPTXYAxis*)yAxis
{
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
	return axisSet.yAxis;
}

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
			lineStyleToEdit = mc.xAxis.axisLineStyle;
			break;
		case EDIT_LINE_STYLE_Y_AXIS:
			lineStyleToEdit = mc.yAxis.axisLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_X:
			lineStyleToEdit = mc.xAxis.majorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_Y:
			lineStyleToEdit = mc.yAxis.majorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_X:
			lineStyleToEdit = mc.xAxis.minorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_Y:
			lineStyleToEdit = mc.yAxis.minorGridLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_X:
			lineStyleToEdit = mc.xAxis.majorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_Y:
			lineStyleToEdit = mc.yAxis.majorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_X:
			lineStyleToEdit = mc.xAxis.minorTickLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_Y:
			lineStyleToEdit = mc.yAxis.minorTickLineStyle;
			break;
	}
	
	 // Sometimes the line style value is nil. In this case, create a "default"
	 // one that matches nothing being draw (i.e. line thickness = 0).
	if (lineStyleToEdit == nil) {
		CPTMutableLineStyle *defaultLineStyle = [CPTMutableLineStyle lineStyle];
		defaultLineStyle.lineWidth = 0.0;
		
		lineStyleToEdit = defaultLineStyle;
	}

	// create the popover
	self.lineStylePopover = [[NSPopover alloc] init];
	
	self.lineStyleViewController = [[CorePlotLineStyleViewController alloc] init];
	[self.lineStyleViewController updateWithLineStyle:lineStyleToEdit];
	
	self.lineStylePopover.contentViewController = self.lineStyleViewController;
	self.lineStylePopover.behavior = NSPopoverBehaviorTransient;
	self.lineStylePopover.delegate = self;

	[self.lineStyleViewController addObserver:self
								   forKeyPath:@"currentLineStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];

	NSButton *targetButton = (NSButton *)sender;
	
	[self.lineStylePopover showRelativeToRect:targetButton.bounds ofView:sender preferredEdge:NSMinYEdge]; // display on top of button
}


#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	DLog(@"");
	CPTLineStyle *newLineStyle = self.lineStyleViewController.currentLineStyle;
	
	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_X_AXIS:
			mc.xAxis.axisLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_Y_AXIS:
			mc.yAxis.axisLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_X:
			mc.xAxis.majorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_GRID_Y:
			mc.yAxis.majorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_X:
			mc.xAxis.minorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_GRID_Y:
			mc.xAxis.minorGridLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_X:
			mc.xAxis.majorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MAJOR_TICK_Y:
			mc.yAxis.majorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_X:
			mc.xAxis.minorTickLineStyle = newLineStyle;
			break;
		case EDIT_LINE_STYLE_MINOR_TICK_Y:
			mc.yAxis.minorTickLineStyle = newLineStyle;
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
					mc.xAxis.axisLineStyle = self.lineStyleViewController.currentLineStyle;
					break;
				case EDIT_LINE_STYLE_Y_AXIS:
					mc.yAxis.axisLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_GRID_X:
					mc.xAxis.majorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_GRID_Y:
					mc.yAxis.majorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_GRID_X:
					mc.xAxis.minorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_GRID_Y:
					mc.xAxis.minorGridLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_TICK_X:
					mc.xAxis.majorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MAJOR_TICK_Y:
					mc.yAxis.majorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_TICK_X:
					mc.xAxis.minorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
					break;
				case EDIT_LINE_STYLE_MINOR_TICK_Y:
					mc.yAxis.minorTickLineStyle = self.lineStyleViewController.currentLineStyle;;
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
