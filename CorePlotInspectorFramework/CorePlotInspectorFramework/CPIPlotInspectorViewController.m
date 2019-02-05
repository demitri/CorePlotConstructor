//
//  CPIPlotInspectorViewController.m
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPIPlotInspectorViewController.h"
#import "CPIPrivateHeader.h"

@interface CPIPlotInspectorViewController ()
@end

#pragma mark -

@implementation CPIPlotInspectorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Ref: http://stackoverflow.com/questions/12557936/loading-a-nib-thats-included-in-a-framework
	NSString *frameworkBundleID = FRAMEWORK_BUNDLE_ID;
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
	
	self = [super initWithNibName:nibNameOrNil bundle:frameworkBundle];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)init
{
	return [self initWithNibName:nil bundle:nil];
}

- (void)commonInit
{
	xibInitialized = NO;
	self.title = @"Untitled!";
}

//- (void)viewDidLoad {
//    [super viewDidLoad];

- (void)awakeFromNib {

	if (xibInitialized)
		return;
}

- (CPTPlot*)plot
{
	if (_plot == nil) {
		_plot = [[self.graph allPlots] objectAtIndex:0];
		NSAssert(_plot != nil, @"the plot was not found"); // DLog(@"plot was not found");
	}
	return _plot;
}


@end
