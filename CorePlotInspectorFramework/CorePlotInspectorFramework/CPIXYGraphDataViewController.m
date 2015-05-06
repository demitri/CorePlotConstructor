//
//  CPIXYGraphDataViewController.m
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 5/6/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPIXYGraphDataViewController.h"
#import "CPIPrivateHeader.h"

@interface CPIXYGraphDataViewController ()

@end

@implementation CPIXYGraphDataViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Ref: http://stackoverflow.com/questions/12557936/loading-a-nib-thats-included-in-a-framework
	NSString *frameworkBundleID = FRAMEWORK_BUNDLE_ID;
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
	
	self = [super initWithNibName:@"CPIXYGraphDataView" bundle:frameworkBundle];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	[super commonInit];
	self.title = @"XYGraph Data";
}

- (void)dealloc
{
	;
}

- (NSArray*)propertiesToObserve
{
	return @[]; // @""];
}

@end
