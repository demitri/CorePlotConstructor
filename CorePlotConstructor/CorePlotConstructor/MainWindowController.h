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

enum {
	PLOT_INSPECTOR_PANEL = 1,
	AXES_INSPECTOR_PANEL,
	PADDING_INSPECTOR_PANEL
};

@interface MainWindowController : NSWindowController
{
	IBOutlet NSSplitView *splitView;
	IBOutlet NSTabView *inspectorTabView;
}

- (IBAction)inspectorPopupAction:(id)sender;

@end
