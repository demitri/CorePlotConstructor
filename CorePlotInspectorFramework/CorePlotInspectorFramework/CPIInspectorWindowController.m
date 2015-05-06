//
//  CPIInspectorWindowController.m
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPIInspectorWindowController.h"
#import "CPCDashPatternValueTransformer.h"
#import "CPIPrivateHeader.h"

@interface CPIInspectorWindowController ()
- (void)commonInit;
@end

#pragma mark -

@implementation CPIInspectorWindowController

- (instancetype)initWithWindowNibName:(NSString *)windowNibName
{
	self = [super initWithWindowNibName:windowNibName];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithGraph:(CPTGraph*)graph
{
	self = [self initWithWindowNibName:@"CPIInspectorWindow"];
	self.graph = graph;
	[self loadWindow]; // need all bindings before graph can be wired up
	[self updateForNewGraph:graph];
	return self;
}

- (void)commonInit
{
	nibInitialized = NO;
	
	// register value transformers
	CPCDashPatternValueTransformer *dashPatternValueTransformer = [[CPCDashPatternValueTransformer alloc] init];
	[CPCDashPatternValueTransformer setValueTransformer:dashPatternValueTransformer
												forName:@"CPCDashPatternValueTransformer"];
	
	// set up number formatters
	NSNumberFormatter *decimalNF = [[NSNumberFormatter alloc] init];
	decimalNF.numberStyle = NSNumberFormatterDecimalStyle;
	decimalNF.usesSignificantDigits = YES;
	decimalNF.maximumSignificantDigits = 1;
	_decimalNumberFormatter = decimalNF;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)awakeFromNib
{
	if (nibInitialized)
		return;
	
//	self.plotInspectorController.graph = self.currentGraphController.graph;
//	self.graphPaddingController.graph = self.currentGraphController.graph;
}

#pragma mark -

// just a convenience method
- (CPTGraph*)graph
{
	NSAssert(FALSE, /*self.currentGraphController != nil */ @"trying to access a graph before it's set.");
//	return self.currentGraphController.graph;
	return nil;
}

- (void)updateForNewGraph:(CPTGraph*)graph
{
	// This gets called when the "graph" property is updated
	// - set things up for a new graph.
	
	[inspectorPopupButton removeAllItems];

	if ([graph isKindOfClass:CPTXYGraph.class]) {
		
		CPTXYGraph *xyGraph = (CPTXYGraph*)graph;
		
		NSTabViewItem *tabViewItem;
		unsigned int i = 0;
		
		// select appropriate inspectors
		// -----------------------------
		
		for (NSTabViewItem *item in inspectorTabView.tabViewItems)
			[inspectorTabView removeTabViewItem:item];
		
		self.graphPropertiesController = [[CPIGraphPropertiesController alloc] init];
		self.graphPropertiesController.graph = xyGraph;
		tabViewItem = [[NSTabViewItem alloc] initWithIdentifier:@"GraphProperties"];
		tabViewItem.view = self.graphPropertiesController.view;
		[inspectorTabView insertTabViewItem:tabViewItem atIndex:i];
		[inspectorPopupButton addItemWithTitle:self.graphPropertiesController.title];
		[inspectorPopupButton itemAtIndex:i].keyEquivalent = [NSString stringWithFormat:@"%d", i+1];
		[inspectorPopupButton itemAtIndex:i].tag = i;
		i++;
		
		self.xyGraphAxesController = [[CPIXYGraphAxesViewController alloc] init];
		self.xyGraphAxesController.graph = xyGraph;
		tabViewItem = [[NSTabViewItem alloc] initWithIdentifier:@"XYGraphAxes"];
		tabViewItem.view = self.xyGraphAxesController.view;
		[inspectorTabView insertTabViewItem:tabViewItem atIndex:i];
		[inspectorPopupButton addItemWithTitle:self.xyGraphAxesController.title];
		[inspectorPopupButton itemAtIndex:i].keyEquivalent = [NSString stringWithFormat:@"%d", i+1];
		[inspectorPopupButton itemAtIndex:i].tag = i;
		i++;
		
		self.xyGraphAxisLabelsController = [[CPIXYGraphAxisLabelsViewController alloc] init];
		self.xyGraphAxisLabelsController.graph = xyGraph;
		tabViewItem = [[NSTabViewItem alloc] initWithIdentifier:@"XYGraphAxisLabels"];
		tabViewItem.view = self.xyGraphAxisLabelsController.view;
		[inspectorTabView insertTabViewItem:tabViewItem atIndex:i];
		[inspectorPopupButton addItemWithTitle:self.xyGraphAxisLabelsController.title];
		[inspectorPopupButton itemAtIndex:i].keyEquivalent = [NSString stringWithFormat:@"%d", i+1];
		[inspectorPopupButton itemAtIndex:i].tag = i;
		i++;
		
		self.graphPaddingController = [[CPIGraphPaddingViewController alloc] init];
		self.graphPaddingController.graph = xyGraph;
		tabViewItem = [[NSTabViewItem alloc] initWithIdentifier:@"GraphPadding"];
		tabViewItem.view = self.graphPaddingController.view;
		[inspectorTabView insertTabViewItem:tabViewItem atIndex:i];
		[inspectorPopupButton addItemWithTitle:self.graphPaddingController.title];
		[inspectorPopupButton itemAtIndex:i].keyEquivalent = [NSString stringWithFormat:@"%d", i+1];
		[inspectorPopupButton itemAtIndex:i].tag = i;
		i++;
		
	} else {
		NSAssert(FALSE, @"This type of graph ('%@') not yet supported.", self.graph);
	}
}

#pragma mark -

- (IBAction)inspectorPopupAction:(id)sender
{
	NSPopUpButton *popupButton = (NSPopUpButton*)sender;
	[inspectorTabView selectTabViewItemAtIndex:popupButton.selectedItem.tag];
}

#pragma mark -

// Used as a value for binding.
- (NSNumber*)zeroValue { return @0; }


@end
