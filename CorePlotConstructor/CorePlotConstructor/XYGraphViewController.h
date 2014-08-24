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
#import "XYGraphAxisLabelsViewController.h"
#import "CorePlotLineStyleViewController.h"
#import "CorePlotTextStyleViewController.h"

@class XYGraphAxisLabelsViewController;

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
	
	IBOutlet NSPopUpButton *themePopup;
	NSArray *axisPolicyNames;
	NSArray *anchorStyleNames;
	//IBOutlet NSPopUpButton *graphTitleFontPopup;
	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
	
	IBOutlet XYGraphAxisLabelsViewController *axisLabelsController;
}

@property (strong, nonatomic) CPTXYGraph *graph;
@property (weak) IBOutlet CPTGraphHostingView *graphView;

// properties for editing CPTLineStyle objects
@property (strong, nonatomic) NSPopover *lineStylePopover;
@property (strong, nonatomic) CorePlotLineStyleViewController *lineStyleViewController;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;

// properties for editing CPTTextStyle objects
@property (strong, nonatomic) NSPopover *textStylePopover;
@property (strong, nonatomic) CorePlotTextStyleViewController *textStyleViewController;

// Graph title properties
@property (strong, nonatomic) NSColor *titleColor;
@property (assign) CGFloat graphTitleDisplacementX;
@property (assign) CGFloat graphTitleDisplacementY;

// Data containers
@property (strong, nonatomic) NSMutableArray *xData;
@property (strong, nonatomic) NSMutableArray *yData;
@property (strong, nonatomic) NSMutableArray *xyData;

@property (strong) CPTMutableLineStyle *majorGridLineStyle;
@property (strong) CPTMutableLineStyle *minorGridLineStyle;

@property (weak) CPTXYAxis *xAxis;
@property (weak) CPTXYAxis *yAxis;

- (NSNumber*)minYValue;
- (IBAction)changeTheme:(id)sender;
//- (IBAction)changeGraphTitleFont:(id)sender;
- (IBAction)changeTitleAnchorStyle:(id)sender;

- (IBAction)editLineStyle:(id)sender;
- (IBAction)editTextStyle:(id)sender;

@end
