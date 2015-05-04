//
//  CPIXYGraphAxisLabelsViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/20/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "CPITextStyleViewController.h"
//#import "CPIXYGraphController.h"
//#import "CPIInspectorWindowController.h"

//@class CPIInspectorWindowController;

// text fields
enum AXIS_LABELS_VIEW_TEXT_FIELDS {
	LABEL_OFFSET_X = 1,
	LABEL_OFFSET_Y,
	TITLE_OFFSET_X,
	TITLE_OFFSET_Y
};

enum LABEL_TEXT_STYLE_BUTTONS {
	EDIT_TEXT_STYLE_LABEL_X = 1,
	EDIT_TEXT_STYLE_LABEL_Y,
	EDIT_TEXT_STYLE_AXIS_TITLE_X,
	EDIT_TEXT_STYLE_AXIS_TITLE_Y,
	EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_X,
	EDIT_TEXT_STYLE_MINOR_TICK_LABEL_STYLE_Y
};

@class CPIXYGraphController;

@interface CPIXYGraphAxisLabelsViewController : NSViewController <NSTextFieldDelegate, NSPopoverDelegate>
{
	BOOL xibInitialized;
	IBOutlet NSPopUpButton *tickLabelDirXPopupButton;
	IBOutlet NSPopUpButton *tickLabelDirYPopupButton;
	IBOutlet NSPopUpButton *minorTickLabelDirXPopupButton;
	IBOutlet NSPopUpButton *minorTickLabelDirYPopupButton;
}

@property (nonatomic, weak) CPTXYGraph *graph;

// convenience properties
@property (nonatomic, readonly) CPTXYAxis *xAxis;
@property (nonatomic, readonly) CPTXYAxis *yAxis;

@property (nonatomic, weak) CPIXYGraphController *xyGraphController;
@property (nonatomic, strong) NSPopover *textStylePopover;
@property (nonatomic, strong) CPITextStyleViewController *textStyleViewController;
@property (nonatomic, assign) NSInteger textStyleBeingEdited;
@property (weak) IBOutlet NSPopUpButton *xAxisLabelingPolicyPopup;
@property (weak) IBOutlet NSPopUpButton *yAxisLabelingPolicyPopup;

- (IBAction)axisPolicyChanged:(id)sender;
- (IBAction)editTextStyle:(id)sender;


@end
