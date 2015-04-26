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
- (void)commonInit;
@end

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

- (void)commonInit
{
	initialized = NO;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];

- (void)awakeFromNib {

	if (initialized)
		return;
	
#pragma mark setup inspector
	[themePopup removeAllItems];
	for ( Class c in [CPTTheme themeClasses] )
		[themePopup addItemWithTitle:[c name]];
	[themePopup selectItemWithTitle:kCPTPlainWhiteTheme];
	
	
	// set up frame anchor popup
	[graphTitleFrameAnchorPopup removeAllItems];
	NSArray *anchorArray = @[@"CPTRectAnchorTop", @"CPTRectAnchorTopLeft", @"CPTRectAnchorTopRight",
							 @"CPTRectAnchorBottom", @"CPTRectAnchorBottomLeft", @"CPTRectAnchorBottomRight",
							 @"CPTRectAnchorLeft", @"CPTRectAnchorRight", @"CPTRectAnchorCenter"];
	[graphTitleFrameAnchorPopup addItemsWithTitles:anchorArray];
	
#pragma mark setup title anchor policy
	// set the tag value to the policy (both integers)
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorTop"].tag = CPTRectAnchorTop;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorTopLeft"].tag = CPTRectAnchorTopLeft;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorTopRight"].tag = CPTRectAnchorTopRight;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorBottom"].tag = CPTRectAnchorBottom;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorBottomLeft"].tag = CPTRectAnchorBottomLeft;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorBottomRight"].tag = CPTRectAnchorBottomRight;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorLeft"].tag = CPTRectAnchorLeft;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorRight"].tag = CPTRectAnchorRight;
	[graphTitleFrameAnchorPopup itemWithTitle:@"CPTRectAnchorCenter"].tag = CPTRectAnchorCenter;

}

- (CPTPlot*)plot
{
	if (_plot == nil) {
		_plot = [[self.graph allPlots] objectAtIndex:0];
		DLog(@"plot was not found"); // NSAssert(_plot != nil, @"the plot was not found");
	}
	return _plot;
}

- (IBAction)changeTheme:(id)sender
{
	NSString *themeName = themePopup.titleOfSelectedItem;
	[self.graph applyTheme:[CPTTheme themeNamed:themeName]];
	
	// Most themes reset the axis labeling policy, so these need to be reset after changing themes.
	[self.inspector.currentGraphController resetLabelingPolicy];
}

- (IBAction)changeTitleAnchorStyle:(id)sender
{
	NSAssert(self.graph != nil, @"The graph property was not set.");
	self.graph.titlePlotAreaFrameAnchor = [(NSPopUpButton*)sender selectedItem].tag;
}

@end
