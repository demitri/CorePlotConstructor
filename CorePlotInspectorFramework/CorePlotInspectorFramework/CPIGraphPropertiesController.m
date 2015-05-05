//
//  CPIGraphPropertiesController.m
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 5/5/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPIGraphPropertiesController.h"
#import "CPIPrivateHeader.h"

@interface CPIGraphPropertiesController ()

@end

#pragma mark -

@implementation CPIGraphPropertiesController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	// Ref: http://stackoverflow.com/questions/12557936/loading-a-nib-thats-included-in-a-framework
	NSString *frameworkBundleID = FRAMEWORK_BUNDLE_ID;
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];

	self = [super initWithNibName:@"CPIGraphProperties" bundle:frameworkBundle];
	if (self) {
		;
	}
	return self;
}

- (void)commonInit
{
	[super commonInit];
	self.title = @"Graph Properties";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib
{
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

	// Set up text style popover
	// -------------------------
	// create the text style popover
	self.textStylePopover = [[NSPopover alloc] init];
	self.textStylePopover.behavior = NSPopoverBehaviorTransient;
	self.textStylePopover.delegate = self;
	
	self.textStyleViewController = [[CPITextStyleViewController alloc] init];
	self.textStylePopover.contentViewController = self.textStyleViewController;
	
	[self.textStyleViewController addObserver:self
								   forKeyPath:@"currentTextStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];
}

- (void)dealloc
{
	[self.lineStyleViewController removeObserver:self forKeyPath:@"currentLineStyle"];
	[self.textStyleViewController removeObserver:self forKeyPath:@"currentTextStyle"];
}

- (IBAction)editLineStyle:(id)sender
{
	self.lineStyleBeingEdited = [sender tag];
	
	CPTScatterPlot *plot = (CPTScatterPlot*)[self.graph plotWithIdentifier:kScatterPlot];
	
	CPTLineStyle *lineStyleToEdit = nil;
	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_GRAPH_BORDER:
			lineStyleToEdit = self.graph.plotAreaFrame.borderLineStyle;
			break;
//		case EDIT_LINE_STYLE_DATA:
//			lineStyleToEdit = plot.dataLineStyle;
//			break;
	}
	
	// create the popover
	self.lineStylePopover = [[NSPopover alloc] init];
	
	if (self.lineStyleViewController == nil) {
		self.lineStyleViewController = [[CPILineStyleViewController alloc] init];
	} else {
		// don't want messages while it's being set up
		[self.lineStyleViewController removeObserver:self forKeyPath:@"currentLineStyle"];
	}
	
	[self.lineStyleViewController updateWithLineStyle:lineStyleToEdit];
	
	self.lineStylePopover.contentViewController = self.lineStyleViewController;
	self.lineStylePopover.behavior = NSPopoverBehaviorTransient;
	self.lineStylePopover.delegate = self;
	
	[self.lineStyleViewController addObserver:self
								   forKeyPath:@"currentLineStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];
	
	NSButton *targetButton = (NSButton *)sender;
	[self.lineStylePopover showRelativeToRect:targetButton.bounds
									   ofView:sender
								preferredEdge:NSMinYEdge]; // display on top of button
}

- (IBAction)editTextStyle:(id)sender
{
	CPTTextStyle *textStyleToEdit = self.graph.titleTextStyle;
	NSAssert(textStyleToEdit != nil, @"need to create a default text style");
	
	[self.textStyleViewController updateWithTextStyle:textStyleToEdit];
	
	[self.textStylePopover showRelativeToRect:((NSButton*)sender).bounds
									   ofView:sender
								preferredEdge:NSMinYEdge];
}

- (IBAction)changeTheme:(id)sender
{
	NSString *themeName = themePopup.titleOfSelectedItem;
	[self.graph applyTheme:[CPTTheme themeNamed:themeName]];
	
	// Most themes reset the axis labeling policy, so these need to be reset after changing themes.
	// Send an array of tag values, one for each index. This isn't the cleanest method,
	// but am striving for encapsulation.
	// TODO: find the right way to do this - notification?
	//	[self.graphController resetLabelingPolicy:@[[NSNumber numberWithLong:self.axisLabelsController.xAxisLabelingPolicyPopup.selectedItem.tag],
	//																 [NSNumber numberWithLong:self.axisLabelsController.xAxisLabelingPolicyPopup.selectedItem.tag]]];
}

- (IBAction)changeTitleAnchorStyle:(id)sender
{
	NSAssert(self.graph != nil, @"The graph property was not set.");
	self.graph.titlePlotAreaFrameAnchor = [(NSPopUpButton*)sender selectedItem].tag;
}

#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	NSPopover *popover = notification.object;
	if (popover == self.lineStylePopover) {
		
		CPTLineStyle *newLineStyle = self.lineStyleViewController.currentLineStyle;
		
		switch (self.lineStyleBeingEdited) {
			case EDIT_LINE_STYLE_GRAPH_BORDER:
				self.graph.plotAreaFrame.borderLineStyle = newLineStyle;
				break;
			default:
				break;
		}
		self.lineStylePopover = nil;
		
	} else if (popover == self.textStylePopover) {
		self.graph.titleTextStyle = self.textStyleViewController.currentTextStyle;
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self.textStyleViewController) {
		
		if ([keyPath isEqualToString:@"currentTextStyle"])
			self.graph.titleTextStyle = self.textStyleViewController.currentTextStyle;
	}
	
}

@end
