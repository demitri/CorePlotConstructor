//
//  MainWindowController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 9/29/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	[self.window makeKeyAndOrderFront:nil];
	
	/*
	// set up graph
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"xy_data" ofType:@"plist"];
	NSAssert(plistPath != nil, @"The data file was not found!");
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	// Convert string array to NSNumber arrays
	self.xData = [data objectForKey:@"x_points"];
	self.yData = [data objectForKey:@"y_points"];
	self.xyData = [NSMutableArray array];
	
	for (unsigned int i=0; i < [self.yData count]; i++) {
		[self.xyData addObject:@{[self.yData objectAtIndex:i]: @"y", [self.xData objectAtIndex:i] : @"x"}];
	}
	 */
}

- (IBAction)exportPlotDescription:(id)sender
{
	
}

- (IBAction)openPlotDescription:(id)sender
{
	
}


@end
