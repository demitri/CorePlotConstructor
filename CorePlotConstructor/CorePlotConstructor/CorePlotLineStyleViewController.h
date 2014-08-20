//
//  CorePlotLineStyleViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

/*
 This is a controller for an NSPopupView.
 This class is an editor for CPTLineStyle objects.
 */

@interface CorePlotLineStyleViewController : NSViewController
{
	IBOutlet NSPopUpButton *lineCapPopupButton;
	IBOutlet NSPopUpButton *lineJoinPopupButton;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, strong) CPTLineStyle *lineStyle;

@end
