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
@property (nonatomic, strong) NSArray *propertiesToObserve;
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
	[self updateForNewGraph:graph];
	return self;
}

- (void)commonInit
{
	nibInitialized = NO;
	self.propertiesToObserve = @[@"graphTitleDisplacementX", @"graphTitleDisplacementY",
								 @"titleColor", @"dataColor",
								 @"borderLineWidth", @"borderLineColor"];
	
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
	
	self.lineStyleViewController = nil;
	
	// create the text style popover
	self.textStylePopover = [[NSPopover alloc] init];
	self.textStylePopover.behavior = NSPopoverBehaviorTransient;
	self.textStylePopover.delegate = self;
	
	self.textStyleViewController = [[CPITextStyleViewController alloc] init];
	self.textStylePopover.contentViewController = self.textStyleViewController;
	
	// set up observing
	// ----------------
	for (NSString *property in [self propertiesToObserve]) {
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}

	[self.textStyleViewController addObserver:self
								   forKeyPath:@"currentTextStyle"
									  options:NSKeyValueObservingOptionNew
									  context:nil];
}

- (void)dealloc
{
	for (NSString *property in [self propertiesToObserve])
		[self removeObserver:self forKeyPath:property];
	
	[self.lineStyleViewController removeObserver:self forKeyPath:@"currentLineStyle"];
	[self.textStyleViewController removeObserver:self forKeyPath:@"currentTextStyle"];
}


- (void)windowDidLoad {
    [super windowDidLoad];
}

- (void)awakeFromNib
{
	if (nibInitialized)
		return;
	
	self.plotInspectorController.graph = self.currentGraphController.graph;
}

#pragma mark -

// just a convenience method
- (CPTGraph*)graph
{
	NSAssert(self.currentGraphController != nil, @"trying to access a graph before it's set.");
	return self.currentGraphController.graph;
}

- (void)updateForNewGraph:(CPTGraph*)graph
{
	// This gets called when the "graph" property is updated
	// - set things up for a new graph.
	
	if ([graph isKindOfClass:CPTXYGraph.class]) {
		
		CPTXYGraph *xyGraph = (CPTXYGraph*)graph;
		if (self.xyGraphController == nil)
			self.xyGraphController = [[CPIXYGraphController alloc] initWithGraph:xyGraph];
		self.xyGraphController.graph = xyGraph;
		self.currentGraphController = self.xyGraphController;
		
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

- (IBAction)editLineStyle:(id)sender
{
	self.lineStyleBeingEdited = [sender tag];
	
	CPTScatterPlot *plot = (CPTScatterPlot*)[self.graph plotWithIdentifier:kScatterPlot];
	
	CPTLineStyle *lineStyleToEdit = nil;
	switch (self.lineStyleBeingEdited) {
		case EDIT_LINE_STYLE_GRAPH_BORDER:
			lineStyleToEdit = self.graph.plotAreaFrame.borderLineStyle;
			break;
		case EDIT_LINE_STYLE_DATA:
			lineStyleToEdit = plot.dataLineStyle;
			break;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@", change);
	
	if (object == self) {
		
		if ([keyPath isEqualToString:@"graphTitleDisplacementX"]) {
			CGFloat y = self.graph.titleDisplacement.y; // current value
			self.graph.titleDisplacement = (CGPoint){ self.graphTitleDisplacementX, y };

		} else if ([keyPath isEqualToString:@"graphTitleDisplacementY"]) {
			CGFloat x = self.graph.titleDisplacement.x; // current value
			self.graph.titleDisplacement = (CGPoint){ x, self.graphTitleDisplacementY };
			
		} else {
			NSLog(@"Uncaught keyPath on %@ observed: %@", object, keyPath);
		}
		
	} else if (object == self.graph) {
		
		if ([keyPath isEqualToString:@"titleDisplacement"]) {
			self.graphTitleDisplacementX = self.graph.titleDisplacement.x;
			self.graphTitleDisplacementY = self.graph.titleDisplacement.y;
		}
		
	} else if (object == self.lineStyleViewController) {
		if ([keyPath isEqualToString:@"currentLineStyle"]) {
			
			CPTScatterPlot *plot = (CPTScatterPlot*)[self.graph plotWithIdentifier:kScatterPlot];
			
			switch (self.lineStyleBeingEdited) {
				case EDIT_LINE_STYLE_GRAPH_BORDER:
					self.graph.plotAreaFrame.borderLineStyle = self.lineStyleViewController.currentLineStyle;
					break;
				case EDIT_LINE_STYLE_DATA:
					plot.dataLineStyle = self.lineStyleViewController.currentLineStyle;
					break;
				default:
					break;
			}
		} else {
			NSLog(@"Uncaught keyPath on %@ observed: %@", object, keyPath);
		}
		
	} else if (object == self.textStyleViewController) {
		
		if ([keyPath isEqualToString:@"currentTextStyle"])
			self.graph.titleTextStyle = self.textStyleViewController.currentTextStyle;
		
	} else
		DLog(@"Uncaught object: %@", object);
}

#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidClose:(NSNotification *)notification
{
	NSPopover *popover = notification.object;
	CPTScatterPlot *plot = (CPTScatterPlot*)[self.graph plotWithIdentifier:kScatterPlot];
	
	if (popover == self.lineStylePopover) {
		
		CPTLineStyle *newLineStyle = self.lineStyleViewController.currentLineStyle;
		
		switch (self.lineStyleBeingEdited) {
			case EDIT_LINE_STYLE_GRAPH_BORDER:
				self.graph.plotAreaFrame.borderLineStyle = newLineStyle;
				break;
			case EDIT_LINE_STYLE_DATA:
				plot.dataLineStyle = newLineStyle;
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
#pragma mark NSTextViewDelegate methods

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
	//DLog(@"%@", notification);
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number
		
		CGFloat delta = command == @selector(moveUp:) ? +1. : -1.;
		
		switch (control.tag) {
				
			case GRAPH_TITLE_DISPLACEMENT_X:
				self.graphTitleDisplacementX = [[NSNumber numberWithFloat:[number floatValue] + delta] floatValue];
				return YES;
				break;
				
			case GRAPH_TITLE_DISPLACEMENT_Y:
				self.graphTitleDisplacementY = [[NSNumber numberWithFloat:[number floatValue] + delta] floatValue];
				return YES;
				break;
				
		}
		
		return NO;
	}
	
	return NO;
}

#pragma mark -



@end
