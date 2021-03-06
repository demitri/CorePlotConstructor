//
//  CPIGraphPaddingViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "CPIPlotInspectorViewController.h"

//@class CPIGraphViewController, CPIInspectorWindowController;

enum {
	GRAPH_PADDING_TOP = 1,
	GRAPH_PADDING_BOTTOM,
	GRAPH_PADDING_LEFT,
	GRAPH_PADDING_RIGHT,
	PLOT_AREA_FRAME_TOP,
	PLOT_AREA_FRAME_BOTTOM,
	PLOT_AREA_FRAME_LEFT,
	PLOT_AREA_FRAME_RIGHT
};

@interface CPIGraphPaddingViewController : CPIPlotInspectorViewController <NSTextFieldDelegate>

//@property (nonatomic, weak) IBOutlet CPTGraph *graph;

@end
