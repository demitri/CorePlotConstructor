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

enum {
	MAJOR_GRID_LINE_WIDTH_X = 1,
	MAJOR_GRID_LINE_WIDTH_Y,
	MINOR_GRID_LINE_WIDTH_X,
	MINOR_GRID_LINE_WIDTH_Y,
	MINOR_TICKS_PER_INTERVAL_X,
	MINOR_TICKS_PER_INTERVAL_Y
};

@interface XYGraphAxesViewController : NSViewController <NSTextFieldDelegate>
{
	IBOutlet XYGraphViewController *mc; // main controller
}

@property (weak, nonatomic, readonly) CPTXYGraph *graph;

@end