//
//  XYGraphViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 10/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "XYGraphPaddingViewController.h"

enum {
	GRAPH_BORDER_LINE_WIDTH = 1,
	GRAPH_TITLE_SIZE,
	GRAPH_TITLE_DISPLACEMENT_X,
	GRAPH_TITLE_DISPLACEMENT_Y
};

@interface XYGraphViewController : NSViewController <CPTPlotDataSource, CPTPlotSpaceDelegate, NSTextFieldDelegate>
{
	// Plot Inspector
	// --------------

	// Padding Inspector
	// -----------------
	
	// Axes Inspector
	// --------------
	
	// ===
	
	IBOutlet NSPopUpButton *themePopup;
	IBOutlet NSPopUpButton *xAxisLabellingPolicyPopup;
	IBOutlet NSPopUpButton *yAxisLabellingPolicyPopup;
	NSArray *axisPolicyNames;
	NSArray *anchorStyleNames;
	IBOutlet NSPopUpButton *graphTitleFontPopup;
	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
	
}

// Graph title properties
@property (strong, nonatomic) IBOutlet NSColor *titleColor;
@property (assign) CGFloat graphTitleDisplacementX;
@property (assign) CGFloat graphTitleDisplacementY;

// Graph border properties
@property (assign, nonatomic) CGFloat borderLineWidth;
@property (strong, nonatomic) IBOutlet NSColor *borderLineColor;

@property (strong, nonatomic) IBOutlet NSColor *dataColor;

@property (strong, nonatomic) NSMutableArray *xData;
@property (strong, nonatomic) NSMutableArray *yData;
@property (strong, nonatomic) NSMutableArray *xyData;

@property (weak) IBOutlet CPTGraphHostingView *graphView;
@property (strong, nonatomic) CPTXYGraph *graph;

@property (strong) CPTMutableLineStyle *majorGridLineStyle;
@property (strong) CPTMutableLineStyle *minorGridLineStyle;

@property (weak) CPTXYAxis *xAxis;
@property (weak) CPTXYAxis *yAxis;

- (NSNumber*)minYValue;
- (IBAction)changeTheme:(id)sender;
- (IBAction)changeGraphTitleFont:(id)sender;
- (IBAction)axisPolicyChanged:(id)sender;
- (IBAction)changeTitleAnchorStyle:(id)sender;


@end
