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

// text fields
enum AXIS_LABELS_VIEW_TEXT_FIELDS {
	LABEL_OFFSET_X = 1,
	LABEL_OFFSET_Y,
	TITLE_OFFSET_X,
	TITLE_OFFSET_Y
};

@class XYGraphViewController;

@interface XYGraphAxisLabelsViewController : NSViewController <NSTextFieldDelegate>
{
	IBOutlet XYGraphViewController *mc; // main controller
	IBOutlet NSPopUpButton *tickLabelDirXPopupButton;
	IBOutlet NSPopUpButton *tickLabelDirYPopupButton;
	IBOutlet NSPopUpButton *minorTickLabelDirXPopupButton;
	IBOutlet NSPopUpButton *minorTickLabelDirYPopupButton;
}

@property (weak) IBOutlet NSPopUpButton *xAxisLabellingPolicyPopup;
@property (weak) IBOutlet NSPopUpButton *yAxisLabellingPolicyPopup;

- (IBAction)axisPolicyChanged:(id)sender;


@end
