//
//  CPIPlotInspectorViewController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "CPIGraphController.h"

#define kScatterPlot @"scatter plot"

// line styles that could be edited
enum {
	EDIT_LINE_STYLE_GRAPH_BORDER = 1,
	EDIT_LINE_STYLE_DATA,
	EDIT_TEXT_STYLE_TITLE
};

@interface CPIPlotInspectorViewController : NSViewController
{
	BOOL xibInitialized;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, weak) CPTPlot *plot;
@property (nonatomic, weak) CPIGraphController *graphController;

- (void)commonInit;
@end
