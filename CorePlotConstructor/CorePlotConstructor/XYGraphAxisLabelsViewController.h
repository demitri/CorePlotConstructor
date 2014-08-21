//
//  XYGraphAxisLabelsViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/20/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "XYGraphViewController.h"

@class XYGraphViewController;

@interface XYGraphAxisLabelsViewController : NSViewController <NSTextFieldDelegate>
{
	IBOutlet XYGraphViewController *mc; // main controller
}

@property (weak) IBOutlet NSPopUpButton *xAxisLabellingPolicyPopup;
@property (weak) IBOutlet NSPopUpButton *yAxisLabellingPolicyPopup;

- (IBAction)axisPolicyChanged:(id)sender;


@end
