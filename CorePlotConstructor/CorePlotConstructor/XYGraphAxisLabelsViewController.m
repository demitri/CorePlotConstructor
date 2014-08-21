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
	
	[self.xAxisLabellingPolicyPopup removeAllItems];
	[self.yAxisLabellingPolicyPopup removeAllItems];
	NSArray *policyArray = @[@"None", @"LocationsProvided", @"FixedInterval",
							 @"Automatic", @"EqualDivisions"];
	[self.xAxisLabellingPolicyPopup addItemsWithTitles:policyArray];
	[self.yAxisLabellingPolicyPopup addItemsWithTitles:policyArray];
	
	// set the tag value to the policy (both integers)
	for (NSPopUpButton *popup in @[self.xAxisLabellingPolicyPopup, self.yAxisLabellingPolicyPopup]) {
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








@end
