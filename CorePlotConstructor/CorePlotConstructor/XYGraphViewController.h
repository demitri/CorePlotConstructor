//
//  XYGraphViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 10/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface XYGraphViewController : NSViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>
{
	IBOutlet NSPopUpButton *themePopup;
	IBOutlet NSPopUpButton *xAxisLabellingPolicyPopup;
	IBOutlet NSPopUpButton *yAxisLabellingPolicyPopup;
	NSArray *axisPolicyNames;
	NSArray *anchorStyleNames;
	IBOutlet NSPopUpButton *graphTitleFontPopup;
	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
}

@property (strong, nonatomic) NSMutableArray *xData;
@property (strong, nonatomic) NSMutableArray *yData;
@property (strong, nonatomic) NSMutableArray *xyData;

@property (weak) IBOutlet CPTGraphHostingView *graphView;
@property (strong, nonatomic) CPTXYGraph *graph;

@property (strong) CPTMutableLineStyle *majorGridLineStyle;
@property (strong) CPTMutableLineStyle *minorGridLineStyle;
@property (assign) CGFloat graphTitleDisplacementX;
@property (assign) CGFloat graphTitleDisplacementY;

- (NSNumber*)minYValue;
- (IBAction)changeTheme:(id)sender;
- (IBAction)changeGraphTitleFont:(id)sender;
- (IBAction)axisPolicyChanged:(id)sender;
- (IBAction)changeTitleAnchorStyle:(id)sender;


@end
