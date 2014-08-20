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

- (IBAction)editLineStyle:(id)sender
{
	self.axisBeingEdited = ([sender tag] == EDIT_LINE_STYLE_BUTTON_X_AXIS_MAJOR ||
							[sender tag] == EDIT_LINE_STYLE_BUTTON_X_AXIS_MINOR) ? self.xAxis : self.yAxis;
	self.lineStyleBeingEdited = [sender tag];
	
	// create the popover
	self.lineStylePopover = [[NSPopover alloc] init];
	
	self.lineStyleViewController = [[CorePlotLineStyleViewController alloc] init];

	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_BUTTON_X_AXIS_MAJOR:
		case EDIT_LINE_STYLE_BUTTON_Y_AXIS_MAJOR:
			self.lineStyleViewController.lineStyle = self.axisBeingEdited.majorGridLineStyle;
			break;
		default:
			self.lineStyleViewController.lineStyle = self.axisBeingEdited.minorGridLineStyle;
	}
	self.lineStyleViewController.lineStyle =
	
	self.lineStylePopover.contentViewController = self.lineStyleViewController;
	self.lineStylePopover.behavior = NSPopoverBehaviorTransient;
	self.lineStylePopover.delegate = self;

	NSButton *targetButton = (NSButton *)sender;
	
	[self.lineStylePopover showRelativeToRect:targetButton.bounds ofView:sender preferredEdge:NSMinYEdge]; // display on top of button
}

#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	self.lineStylePopover = nil;
	self.axisBeingEdited = nil;
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
				
			case MAJOR_GRID_LINE_WIDTH_X:
				self.graph.paddingTop += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_BOTTOM:
				self.graph.paddingBottom += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_LEFT:
				self.graph.paddingLeft += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_RIGHT:
				self.graph.paddingRight += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_TOP:
				self.graph.plotAreaFrame.paddingTop += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_BOTTOM:
				self.graph.plotAreaFrame.paddingBottom += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_LEFT:
				self.graph.plotAreaFrame.paddingLeft += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_RIGHT:
				self.graph.plotAreaFrame.paddingRight += delta;
				handled = YES;
				break;
			default:
				break;
		}
		if (handled)
			return YES;
		
		return NO;
	}
	
	return NO;
}

@end
