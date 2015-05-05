//
//  CPIPlotInspectorViewController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
//#import "CPIXYGraphAxisLabelsViewController.h"
#import "CPIGraphController.h"

//@class XYGraphAxisLabelsViewController;

@interface CPIPlotInspectorViewController : NSViewController
{
	BOOL xibInitialized;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, weak) CPTPlot *plot;
@property (nonatomic, weak) CPIGraphController *graphController;
//@property (nonatomic, weak) IBOutlet CPIXYGraphAxisLabelsViewController *axisLabelsController;

- (void)commonInit;
@end
