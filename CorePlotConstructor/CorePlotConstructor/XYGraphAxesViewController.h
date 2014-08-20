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
	LABEL_OFFSET_X,
	LABEL_OFFSET_Y,
	TITLE_OFFSET_X,
	TITLE_OFFSET_Y,
	MINOR_TICKS_PER_INTERVAL_X,
	MINOR_TICKS_PER_INTERVAL_Y,
	TICK_LENGTH_X,
	TICK_LENGTH_Y
};

enum {
	EDIT_LINE_STYLE_BUTTON_X_AXIS_MAJOR = 1,
	EDIT_LINE_STYLE_BUTTON_Y_AXIS_MAJOR,
	EDIT_LINE_STYLE_BUTTON_X_AXIS_MINOR,
	EDIT_LINE_STYLE_BUTTON_Y_AXIS_MINOR
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
@property (nonatomic, weak) CPTXYAxis* axisBeingEdited;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;

- (IBAction)editLineStyle:(id)sender;

@end
