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

enum {
	TEXT_FIELD_LINE_WIDTH = 1,
	TEXT_FIELD_MITER_LIMIT,
	TEXT_FIELD_PHASE
};

@interface CPCDashPattern : NSObject
{
}
@property (nonatomic, strong) NSArray *numericArray;
@property (nonatomic, readonly) NSString *stringValue;

- (id)initWithNumericArray:(NSArray*)array;
+ (CPCDashPattern*)dashPatternfromString:(NSString*)string;

@end

#pragma mark -

@interface CorePlotLineStyleViewController : NSViewController
{
	IBOutlet NSPopUpButton *lineCapPopupButton;
	IBOutlet NSPopUpButton *lineJoinPopupButton;
	IBOutlet NSTextField *dashPatternTextField;
}

@property (nonatomic, weak) CPTGraph *graph;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSColor *lineColor;
@property (nonatomic, assign) CGFloat miterLimit;
@property (nonatomic, strong) NSString *dashPatternString;
@property (nonatomic, assign) CGFloat patternPhase;

@property (nonatomic, strong, readonly) CPTLineStyle *currentLineStyle;

- (IBAction)popupMenuChanged:(id)sender;
- (void)updateWithLineStyle:(CPTLineStyle*)newLineStyle;

@end
