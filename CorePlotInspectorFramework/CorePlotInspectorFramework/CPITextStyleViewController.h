//
//  CPITextStyleViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/23/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

/*
 This is a controller for an NSPopupView.
 This class is an editor for CPTTextStyle objects.
 */

@interface CPITextStyleViewController : NSViewController
{
	IBOutlet NSPopUpButton *fontsPopupButton;
	IBOutlet NSPopUpButton *textAlignmentPopupButton;
	IBOutlet NSPopUpButton *lineBreakModePopupButton;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) NSColor *textColor;


@property (nonatomic, strong, readonly) CPTTextStyle *currentTextStyle;

- (IBAction)popupMenuChanged:(id)sender;
- (void)updateWithTextStyle:(CPTTextStyle*)newTextStyle;

@end
