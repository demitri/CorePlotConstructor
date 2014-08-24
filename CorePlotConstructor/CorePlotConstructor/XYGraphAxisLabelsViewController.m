//
//  XYGraphAxisLabelsViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/20/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "XYGraphAxisLabelsViewController.h"

@interface XYGraphAxisLabelsViewController ()
- (void)initialize;
@end

@implementation XYGraphAxisLabelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	[self initialize];
	return self;
}

- (void)initialize
{
	self.textStyleViewController = [[CorePlotTextStyleViewController alloc] init];

	// set up text style popover inspector
	self.textStylePopover = [[NSPopover alloc] init];
	self.textStylePopover.behavior = NSPopoverBehaviorTransient;
	self.textStylePopover.delegate = self;
	
	self.textStylePopover.contentViewController = self.textStyleViewController;
	
	[self.textStyleViewController addObserver:self
								   forKeyPath:@"currentTextStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];
	
}

- (void)dealloc
{
	[self.textStyleViewController removeObserver:self forKeyPath:@"currentTextStyle"];
}

- (void)awakeFromNib
{
	// ===============
	// Setup inspector
	// ===============
	NSArray *cptSignLabels = @[@"No Offset", @"Positive Offset", @"Negative Offset"];
	for (NSPopUpButton *popup in @[tickLabelDirXPopupButton, tickLabelDirYPopupButton, minorTickLabelDirXPopupButton, minorTickLabelDirYPopupButton]) {
		[popup removeAllItems];
		[popup addItemsWithTitles:cptSignLabels];
		[popup itemWithTitle:@"No Offset"].tag = CPTSignNone;
		[popup itemWithTitle:@"Positive Offset"].tag = CPTSignPositive;
		[popup itemWithTitle:@"Negative Offset"].tag = CPTSignNegative;
	}
	
	
	NSArray *policyArray = @[@"None", @"LocationsProvided", @"FixedInterval",
							 @"Automatic", @"EqualDivisions"];

	// set the tag value to the policy (both integers)
	for (NSPopUpButton *popup in @[self.xAxisLabelingPolicyPopup, self.yAxisLabelingPolicyPopup]) {
		[popup removeAllItems];
		[popup addItemsWithTitles:policyArray];
		[popup itemWithTitle:@"None"].tag = CPTAxisLabelingPolicyNone;
		[popup itemWithTitle:@"LocationsProvided"].tag = CPTAxisLabelingPolicyLocationsProvided;
		[popup itemWithTitle:@"FixedInterval"].tag = CPTAxisLabelingPolicyFixedInterval;
		[popup itemWithTitle:@"Automatic"].tag = CPTAxisLabelingPolicyAutomatic;
		[popup itemWithTitle:@"EqualDivisions"].tag = CPTAxisLabelingPolicyEqualDivisions;
		
		[popup selectItemWithTitle:@"Automatic"];
	}
}

- (IBAction)axisPolicyChanged:(id)sender
{
	NSPopUpButton *popup = sender;
	if (popup == self.xAxisLabelingPolicyPopup)
		mc.xAxis.labelingPolicy = popup.selectedItem.tag;
	else
		mc.yAxis.labelingPolicy = popup.selectedItem.tag;
	//[self.graph reloadData];
}

- (IBAction)editTextStyle:(id)sender
{
	self.textStyleBeingEdited = [sender tag];
	
	CPTTextStyle *textStyleToEdit = nil;
	switch (self.textStyleBeingEdited) {
		case EDIT_TEXT_STYLE_LABEL_X:
			textStyleToEdit = mc.xAxis.labelTextStyle;
			break;
		case EDIT_TEXT_STYLE_LABEL_Y:
			textStyleToEdit = mc.yAxis.labelTextStyle;
			break;
		case EDIT_TEXT_STYLE_AXIS_TITLE_X:
			textStyleToEdit = mc.xAxis.titleTextStyle;
			break;
		case EDIT_TEXT_STYLE_AXIS_TITLE_Y:
			textStyleToEdit = mc.yAxis.titleTextStyle;
			break;
		case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_X:
			textStyleToEdit = mc.xAxis.minorTickLabelTextStyle;
			break;
		case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_Y:
			textStyleToEdit = mc.yAxis.minorTickLabelTextStyle;
			break;
	}
	NSAssert(textStyleToEdit != nil, @"need to create a default text style?");

	[self.textStyleViewController updateWithTextStyle:textStyleToEdit];
	
	[self.textStylePopover showRelativeToRect:((NSButton*)sender).bounds
									   ofView:sender
								preferredEdge:NSMinYEdge];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@", change);
	
	if (object == self.textStyleViewController) {
		if ([keyPath isEqualToString:@"currentTextStyle"]) {
						
			switch (self.textStyleBeingEdited) {
				case EDIT_TEXT_STYLE_LABEL_X:
					mc.xAxis.labelTextStyle = self.textStyleViewController.currentTextStyle;
					break;
				case EDIT_TEXT_STYLE_LABEL_Y:
					mc.yAxis.labelTextStyle = self.textStyleViewController.currentTextStyle;
					break;
				case EDIT_TEXT_STYLE_AXIS_TITLE_X:
					mc.xAxis.titleTextStyle = self.textStyleViewController.currentTextStyle;
					break;
				case EDIT_TEXT_STYLE_AXIS_TITLE_Y:
					mc.yAxis.titleTextStyle = self.textStyleViewController.currentTextStyle;
					break;
				case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_X:
					mc.xAxis.minorTickLabelTextStyle = self.textStyleViewController.currentTextStyle;
					break;
				case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_Y:
					mc.yAxis.minorTickLabelTextStyle = self.textStyleViewController.currentTextStyle;
					break;
			}
		} else {
			NSLog(@"Uncaught keyPath on %@ observed: %@", object, keyPath);
		}
		
	} else
		DLog(@"Uncaught object: %@", object);
}

#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	NSPopover *popover = notification.object;
	
	if (popover == self.textStylePopover) {
		
		switch (self.textStyleBeingEdited) {
			case EDIT_TEXT_STYLE_LABEL_X:
				mc.xAxis.labelTextStyle = self.textStyleViewController.currentTextStyle;
				break;
			case EDIT_TEXT_STYLE_LABEL_Y:
				mc.yAxis.labelTextStyle = self.textStyleViewController.currentTextStyle;
				break;
			case EDIT_TEXT_STYLE_AXIS_TITLE_X:
				mc.xAxis.titleTextStyle = self.textStyleViewController.currentTextStyle;
				break;
			case EDIT_TEXT_STYLE_AXIS_TITLE_Y:
				mc.yAxis.titleTextStyle = self.textStyleViewController.currentTextStyle;
				break;
			case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_X:
				mc.xAxis.minorTickLabelTextStyle = self.textStyleViewController.currentTextStyle;
				break;
			case EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_Y:
				mc.yAxis.minorTickLabelTextStyle = self.textStyleViewController.currentTextStyle;
				break;
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
			case LABEL_OFFSET_X:
				mc.xAxis.labelOffset += delta;
				handled = YES;
				break;
			case LABEL_OFFSET_Y:
				mc.yAxis.labelOffset += delta;
				handled = YES;
				break;
			case TITLE_OFFSET_X:
				mc.xAxis.titleOffset += delta;
				handled = YES;
				break;
			case TITLE_OFFSET_Y:
				mc.yAxis.titleOffset += delta;
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
