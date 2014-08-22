//
//  XYGraphAxisLabelsViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/20/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "XYGraphAxisLabelsViewController.h"

@interface XYGraphAxisLabelsViewController ()

@end

@implementation XYGraphAxisLabelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
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
	for (NSPopUpButton *popup in @[self.xAxisLabellingPolicyPopup, self.yAxisLabellingPolicyPopup]) {
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
	if (popup == self.xAxisLabellingPolicyPopup)
		mc.xAxis.labelingPolicy = popup.selectedItem.tag;
	else
		mc.yAxis.labelingPolicy = popup.selectedItem.tag;
	//[self.graph reloadData];
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
