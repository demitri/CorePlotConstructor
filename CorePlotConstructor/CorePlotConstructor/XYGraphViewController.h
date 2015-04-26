//
//  XYGraphViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 10/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import <CorePlotInspectorFramework/CorePlotInspectorFramework.h>

#define kScatterPlot @"scatter plot"

//@class XYGraphAxisLabelsViewController;

@interface XYGraphViewController : NSViewController <CPTPlotDataSource, CPTPlotSpaceDelegate, NSTextFieldDelegate, NSPopoverDelegate>
{
	// Plot Inspector
	// --------------
	//IBOutlet NSTextField *titleSizeTextField;
	
	// Padding Inspector
	// -----------------
	
	// Axes Inspector
	// --------------
	
	// ===
	
//	IBOutlet NSPopUpButton *themePopup;
//	NSArray *axisPolicyNames;
//	NSArray *anchorStyleNames;
	//IBOutlet NSPopUpButton *graphTitleFontPopup;
//	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
	
//	IBOutlet XYGraphAxisLabelsViewController *axisLabelsController;
}

@property (strong, nonatomic) CPTXYGraph *graph;
@property (weak, nonatomic) CPTPlot *plot;
@property (weak) IBOutlet CPTGraphHostingView *graphView;

// Data containers
@property (strong, nonatomic) NSMutableArray *xData;
@property (strong, nonatomic) NSMutableArray *yData;
@property (strong, nonatomic) NSMutableArray *xyData;

@property (strong) CPTMutableLineStyle *majorGridLineStyle;
@property (strong) CPTMutableLineStyle *minorGridLineStyle;

@property (weak) CPTXYAxis *xAxis;
@property (weak) CPTXYAxis *yAxis;

@property (nonatomic, strong) CPIInspectorWindowController *inspectorWindowController;

- (void)createGraph;
- (NSNumber*)minYValue;
//- (IBAction)changeGraphTitleFont:(id)sender;
//- (IBAction)changeTitleAnchorStyle:(id)sender;

@end
