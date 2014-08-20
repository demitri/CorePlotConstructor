//
//  CorePlotLineStyleViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CorePlotLineStyleViewController.h"

@interface CorePlotLineStyleViewController ()

@end

@implementation CorePlotLineStyleViewController

/* Designated initializer */
- (id)init
{
	NSString *nibName = @"CorePlotLineStyleViewController";
	NSBundle *bundle = nil;
	self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        // init code
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Disregard parameters - nib name is an implementation detail
	return [self init];
}

- (void)awakeFromNib
{
	// set up line cap popup button
	// ----------------------------
	[lineCapPopupButton removeAllItems];
	NSArray *lineCapOptions = @[@"Butt", @"Round", @"Square"];
	[lineCapPopupButton addItemsWithTitles:lineCapOptions];
	[lineCapPopupButton itemWithTitle:@"Butt"].tag = kCGLineCapButt;
	[lineCapPopupButton itemWithTitle:@"Round"].tag = kCGLineCapRound;
	[lineCapPopupButton itemWithTitle:@"Square"].tag = kCGLineCapSquare;
	
	// set up line join popup button
	// -----------------------------
	[lineJoinPopupButton removeAllItems];
	NSArray *lineJoinOptions = @[@"Miter", @"Round", @"Bevel"];
	[lineJoinPopupButton addItemsWithTitles:lineJoinOptions];
	[lineJoinPopupButton itemWithTitle:@"Miter"].tag = kCGLineJoinMiter;
	[lineJoinPopupButton itemWithTitle:@"Round"].tag = kCGLineJoinRound;
	[lineJoinPopupButton itemWithTitle:@"Bevel"].tag = kCGLineJoinBevel;

	
	
}

@end
