//
//  CPIXYGraphAxesViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "CPIPlotInspectorViewController.h"
#import "CPILineStyleViewController.h"

// Text fields
enum {
	MAJOR_TICK_LENGTH_X = 1,
	MAJOR_TICK_LENGTH_Y,
	MINOR_TICK_LENGTH_X,
	MINOR_TICK_LENGTH_Y,
	MINOR_TICKS_PER_INTERVAL_X,
	MINOR_TICKS_PER_INTERVAL_Y,
	MINOR_TICK_LABEL_OFFSET_X,
	MINOR_TICK_LABEL_OFFSET_Y,
	PREF_NO_MAJOR_TICKS_X,		// 0 = Core Plot decide
	PREF_NO_MAJOR_TICKS_Y
};

// line styles that could be edited
enum {
	EDIT_LINE_STYLE_X_AXIS = 1,
	EDIT_LINE_STYLE_Y_AXIS,
	EDIT_LINE_STYLE_MAJOR_GRID_X,
	EDIT_LINE_STYLE_MAJOR_GRID_Y,
	EDIT_LINE_STYLE_MINOR_GRID_X,
	EDIT_LINE_STYLE_MINOR_GRID_Y,
	EDIT_LINE_STYLE_MAJOR_TICK_X,
	EDIT_LINE_STYLE_MAJOR_TICK_Y,
	EDIT_LINE_STYLE_MINOR_TICK_X,
	EDIT_LINE_STYLE_MINOR_TICK_Y
};

@interface CPIXYGraphAxesViewController : CPIPlotInspectorViewController <NSTextFieldDelegate, NSPopoverDelegate>
{
	IBOutlet NSPopUpButton *tickDirectionXPopupButton;
	IBOutlet NSPopUpButton *tickDirectionYPopupButton;
}

//@property (nonatomic, weak) CPTXYGraph *graph;

// convenience properties
@property (nonatomic, readonly) CPTXYAxis *xAxis;
@property (nonatomic, readonly) CPTXYAxis *yAxis;

@property (strong, nonatomic) NSPopover *lineStylePopover;
@property (strong, nonatomic) CPILineStyleViewController *lineStyleViewController;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;
@property (nonatomic, strong, readonly) NSNumber *zeroValue;

- (IBAction)editLineStyle:(id)sender;

@end
