//
//  MainWindowController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 9/29/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import <Quartz/Quartz.h>
#import <CorePlotInspectorFramework/CorePlotInspectorFramework.h>
#import "XYGraphViewController.h"

enum {
	PLOT_INSPECTOR_PANEL = 1,
	AXES_INSPECTOR_PANEL,
	PADDING_INSPECTOR_PANEL
};

@interface MainWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet XYGraphViewController *xyGraphViewController;

// Data containers
@property (strong, nonatomic) NSMutableArray *xData;
@property (strong, nonatomic) NSMutableArray *yData;
@property (strong, nonatomic) NSMutableArray *xyData;

//- (IBAction)inspectorPopupAction:(id)sender;
- (IBAction)exportPlotDescription:(id)sender;
- (IBAction)openPlotDescription:(id)sender;

@end
