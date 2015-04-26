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
#import "XYGraphAxisLabelsViewController.h"

#define kScatterPlot @"scatter plot"
#define kInitialFont @"Helvetica"

@class CPIPlotInspectorViewController, CPIGraphPaddingViewController;
@class CPIGraphController, XYGraphAxisLabelsViewController;

// access the CPTGraph being inspected via self.currentGraphController.graph

// text fields in view
enum {
	GRAPH_BORDER_LINE_WIDTH = 1,
	GRAPH_TITLE_SIZE,
	GRAPH_TITLE_DISPLACEMENT_X,
	GRAPH_TITLE_DISPLACEMENT_Y
};

// line styles that could be edited
enum {
	EDIT_LINE_STYLE_GRAPH_BORDER = 1,
	EDIT_LINE_STYLE_DATA,
	EDIT_TEXT_STYLE_TITLE
};

@interface CPIInspectorWindowController : NSWindowController <NSPopoverDelegate, NSTextViewDelegate, NSControlTextEditingDelegate
>
{
	BOOL nibInitialized;
	IBOutlet NSTabView *inspectorTabView;
}

// Controllers applicable to all graphs
@property (nonatomic, strong) IBOutlet CPIPlotInspectorViewController *plotInspectorController;
@property (nonatomic, strong) IBOutlet CPIGraphPaddingViewController *graphPaddingController;

// Graph-specific controllers
@property (nonatomic, weak) CPIGraphController *currentGraphController;
@property (nonatomic, strong) CPIXYGraphController *xyGraphController;
@property (nonatomic, strong) IBOutlet XYGraphAxisLabelsViewController *axisLabelsController;

//@property (nonatomic, strong) IBOutlet XYGraphAxisLabelsViewController *axisLabelsController;
//@property (nonatomic, strong) IBOutlet XYGraphPaddingViewController *graphPaddingController;

@property (nonatomic, strong, readonly) NSNumberFormatter *decimalNumberFormatter;
//@property (nonatomic, readonly) CPTXYGraph *graph;

// properties for editing CPTLineStyle objects
@property (strong, nonatomic) NSPopover *lineStylePopover;
@property (strong, nonatomic) CPILineStyleViewController *lineStyleViewController;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;

// properties for editing CPTTextStyle objects
@property (strong, nonatomic) NSPopover *textStylePopover;
@property (strong, nonatomic) CPITextStyleViewController *textStyleViewController;

// Graph title properties
@property (strong, nonatomic) NSColor *titleColor;
@property (assign) CGFloat graphTitleDisplacementX;
@property (assign) CGFloat graphTitleDisplacementY;

- (instancetype)initWithGraph:(CPTGraph*)graph;
- (void)updateForNewGraph:(CPTGraph*)graph;
- (IBAction)inspectorPopupAction:(id)sender;

- (IBAction)editLineStyle:(id)sender;
- (IBAction)editTextStyle:(id)sender;

@end
