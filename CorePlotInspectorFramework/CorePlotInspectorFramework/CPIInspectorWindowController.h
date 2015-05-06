//
//  CPIInspectorWindowController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "CPILineStyleViewController.h"
#import "CPIConstraintViewController.h"
#import "CPITextStyleViewController.h"
#import "CPIGraphController.h"
#import "CPIXYGraphController.h"
#import "CPIPlotInspectorViewController.h"
#import "CPIGraphPaddingViewController.h"
#import "CPIXYGraphAxisLabelsViewController.h"
#import "CPIXYGraphAxesViewController.h"
#import "CPIGraphPropertiesController.h"

#define kScatterPlot @"scatter plot"
#define kInitialFont @"Helvetica"

//@class CPIPlotInspectorViewController, CPIGraphPaddingViewController;
//@class CPIGraphController;

// access the CPTGraph being inspected via self.currentGraphController.graph

@interface CPIInspectorWindowController : NSWindowController
{
	BOOL nibInitialized;
	IBOutlet NSTabView *inspectorTabView;
	IBOutlet NSPopUpButton *inspectorPopupButton;
}

// Controllers applicable to all graphs
@property (nonatomic, strong) CPIGraphPropertiesController *graphPropertiesController;
@property (nonatomic, strong) IBOutlet CPIPlotInspectorViewController *plotInspectorController;
@property (nonatomic, strong) CPIGraphPaddingViewController *graphPaddingController;

// Graph-specific controllers
// --------------------------
// CPTXYGraph
//@property (nonatomic, weak) CPIGraphController *currentGraphController;
//@property (nonatomic, strong) CPIXYGraphController *xyGraphController;
@property (nonatomic, strong) CPIXYGraphAxisLabelsViewController *xyGraphAxisLabelsController;
@property (nonatomic, strong) CPIXYGraphAxesViewController *xyGraphAxesController;

@property (nonatomic, strong, readonly) NSNumberFormatter *decimalNumberFormatter;
@property (nonatomic, weak) CPTGraph *graph;

@property (nonatomic, strong, readonly) NSNumber *zeroValue;

- (instancetype)initWithGraph:(CPTGraph*)graph;
- (void)updateForNewGraph:(CPTGraph*)graph;
- (IBAction)inspectorPopupAction:(id)sender;

@end
