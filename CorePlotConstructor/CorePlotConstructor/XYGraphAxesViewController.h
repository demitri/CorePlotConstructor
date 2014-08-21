//
//  XYGraphAxesViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "XYGraphViewController.h"
#import "CorePlotLineStyleViewController.h"

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

@interface XYGraphAxesViewController : NSViewController <NSTextFieldDelegate, NSPopoverDelegate>
{
	IBOutlet XYGraphViewController *mc; // main controller
}

@property (weak, nonatomic, readonly) CPTXYGraph *graph;
@property (strong, nonatomic) NSPopover *lineStylePopover;
@property (strong, nonatomic) CorePlotLineStyleViewController *lineStyleViewController;
@property (nonatomic, weak, readonly) CPTXYAxis *xAxis;
@property (nonatomic, weak, readonly) CPTXYAxis *yAxis;
//@property (nonatomic, weak) CPTXYAxis *axisBeingEdited;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;
@property (nonatomic, strong, readonly) NSNumber *zeroValue;

- (IBAction)editLineStyle:(id)sender;

@end
