//
//  CPIPlotInspectorViewController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "XYGraphAxisLabelsViewController.h"
#import "CPIInspectorWindowController.h"

@class CPIInspectorWindowController;

@interface CPIPlotInspectorViewController : NSViewController
{
	IBOutlet NSPopUpButton *themePopup;
	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
	BOOL initialized;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, weak) CPTPlot *plot;
@property (nonatomic, weak) IBOutlet CPIInspectorWindowController *inspector;
@property (nonatomic, weak) IBOutlet XYGraphAxisLabelsViewController *axisLabelsController;

- (IBAction)changeTheme:(id)sender;
- (IBAction)changeTitleAnchorStyle:(id)sender;

@end
