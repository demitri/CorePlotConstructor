//
//  XYGraphViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 10/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "XYGraphViewController.h"

#define kScatterPlot @"scatter plot"
#define kInitialFont @"Helvetica"

#pragma mark -

@interface XYGraphViewController ()

- (NSArray*)propertiesToObserve;

@end

#pragma mark -

@implementation XYGraphViewController

//@synthesize graph, graphView;
//@synthesize xData, yData, xyData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"xy_data" ofType:@"plist"];
	NSAssert(plistPath != nil, @"The data file was not found!");
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	// Convert string array to NSNumber arrays
	self.xData = [data objectForKey:@"x_points"];
	self.yData = [data objectForKey:@"y_points"];
	self.xyData = [NSMutableArray array];
	
	for (unsigned int i=0; i < [self.yData count]; i++) {
		[self.xyData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self.yData objectAtIndex:i], @"y",
									  [self.xData objectAtIndex:i], @"x", nil]];
	}
	
	// ===============
	// Setup inspector
	// ===============
#pragma mark setup inspector
	[themePopup removeAllItems];
    for ( Class c in [CPTTheme themeClasses] )
        [themePopup addItemWithTitle:[c name]];
	[themePopup selectItemWithTitle:kCPTPlainWhiteTheme];
	
	[xAxisLabellingPolicyPopup removeAllItems];
	[yAxisLabellingPolicyPopup removeAllItems];
	NSArray *policyArray = @[@"None", @"LocationsProvided", @"FixedInterval",
							 @"Automatic", @"EqualDivisions"];
	[xAxisLabellingPolicyPopup addItemsWithTitles:policyArray];
	[yAxisLabellingPolicyPopup addItemsWithTitles:policyArray];

	// set the tag value to the policy (both integers)
	for (NSPopUpButton *popup in @[xAxisLabellingPolicyPopup, yAxisLabellingPolicyPopup]) {
		[popup itemWithTitle:@"None"].tag = CPTAxisLabelingPolicyNone;
		[popup itemWithTitle:@"LocationsProvided"].tag = CPTAxisLabelingPolicyLocationsProvided;
		[popup itemWithTitle:@"FixedInterval"].tag = CPTAxisLabelingPolicyFixedInterval;
		[popup itemWithTitle:@"Automatic"].tag = CPTAxisLabelingPolicyAutomatic;
		[popup itemWithTitle:@"EqualDivisions"].tag = CPTAxisLabelingPolicyEqualDivisions;
		
		[popup selectItemWithTitle:@"Automatic"];
	}
	
	
	// fonts
#pragma mark setup fonts
	[graphTitleFontPopup removeAllItems];
	for (NSString *fontName in [[NSFontManager sharedFontManager] availableFontFamilies])
		[graphTitleFontPopup addItemWithTitle:fontName];
	[graphTitleFontPopup selectItemWithTitle:kInitialFont];
	
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
	
	// ===========
	// Setup graph
	// ===========
	
	// ------------
	// Create graph
	// ------------
	CGRect bounds = NSRectToCGRect(self.graphView.bounds);
	self.graph = [[CPTXYGraph alloc] initWithFrame:bounds];
	
	// -----------
	// apply theme
	// -----------
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];//kCPTDarkGradientTheme];
	[self.graph applyTheme:theme];
	self.graphView.hostedGraph = self.graph;
	
	// -----------
	// graph title
	// -----------
#pragma mark set up graph title
	self.graph.title = @"CPTXYGraph Plot Title";
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color = [CPTColor grayColor];
	textStyle.fontName = kInitialFont; // @"Helvetica-Bold";
	textStyle.fontSize = 18.0;
	//	textStyle.fontSize = round(bounds.size.height / (CGFloat)20.0);
	self.graph.titleTextStyle = textStyle;
	//	graph.titleDisplacement = CGPoint{0.0, 10.0};
	self.graph.titleDisplacement = (CGPoint){ 0.0f, round(bounds.size.height / (CGFloat)18.0) }; // Ensure that title displacement falls on an integral pixel
	self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	[graphTitleFrameAnchorPopup selectItemWithTag:CPTRectAnchorTop];
	
	self.graphTitleDisplacementX = self.graph.titleDisplacement.x;
	self.graphTitleDisplacementY = self.graph.titleDisplacement.y;
	self.titleColor = textStyle.color.nsColor;
	
	// ------------
	// graph border
	// ------------
#pragma mark set up graph border
	CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor = [CPTColor blackColor];
	borderLineStyle.lineWidth = 1.0;
	self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
	
	self.borderLineColor = borderLineStyle.lineColor.nsColor;
	self.borderLineWidth = borderLineStyle.lineWidth;
	
	// -------------
	// Graph padding
	// -------------
	//    * how much to inset the x/y region (plot space) from the view
	//			e.g. to make room for labels
	//	  * default value in each direction: 20 pixels
	//	  * plot axis labels will not be drawn in this area
	//
	CGFloat boundsPadding = round(bounds.size.width / (CGFloat)20.0); // Ensure that padding falls on an integral pixel
	
	self.graph.paddingLeft = boundsPadding;
	if ( self.graph.titleDisplacement.y > 0.0 ) {
		self.graph.paddingTop = self.graph.titleDisplacement.y * 2;
	}
	else {
		self.graph.paddingTop = boundsPadding;
	}
	
	self.graph.paddingRight	= boundsPadding;
	self.graph.paddingBottom = boundsPadding;
	
	self.graph.plotAreaFrame.paddingTop	   = 15.0;
	self.graph.plotAreaFrame.paddingRight  = 15.0;
	self.graph.plotAreaFrame.paddingBottom = 55.0;
	self.graph.plotAreaFrame.paddingLeft   = 55.0;
	
	/*	graph.paddingLeft	= 20.0;
	 graph.paddingTop	= 20.0;
	 graph.paddingRight	= 20.0;
	 graph.paddingBottom = 20.0;
	 */
	//	graph.plotAreaFrame.paddingTop    = 20.0;
	//	graph.plotAreaFrame.paddingBottom = 50.0;
	//	graph.plotAreaFrame.paddingLeft   = 50.0;
	//	graph.plotAreaFrame.paddingRight  = 50.0;
	
	// ==========
	// Setup axes
	// ==========
	
	// setup scatterplot space
	//CPTScatterPlot *plotSpace = [[CPTScatterPlot alloc] init];
	//plotSpace.allowsUserInteraction = YES;
	
	// ----------------
	// grid line styles
	// ----------------
#pragma mark set up grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 0.75;
	majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
	
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 0.25;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
	
	// ====
	// Axes
	// ====
#pragma set up axes
	// Label x axis with a fixed interval policy
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
	self.xAxis = axisSet.xAxis;
	self.xAxis.labelingPolicy					= CPTAxisLabelingPolicyAutomatic;
	self.xAxis.orthogonalCoordinateDecimal		= CPTDecimalFromUnsignedInteger(0); // where to draw the x axis (y=...)
	//	self.xAxis.minorTicksPerInterval        = 4;
	//	self.xAxis.preferredNumberOfMajorTicks	= 8;
	self.xAxis.majorGridLineStyle              = majorGridLineStyle;
	self.xAxis.minorGridLineStyle              = minorGridLineStyle;
	self.xAxis.title                           = @"wavelengths";
	self.xAxis.titleOffset                     = 20.0;
	NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
	labelFormatter.numberStyle = NSNumberFormatterNoStyle; // NSNumberFormatterScientificStyle
	self.xAxis.labelFormatter		   = labelFormatter;
	
	// Label y with an automatic label policy.
	self.yAxis = axisSet.yAxis;
	self.yAxis.labelingPolicy                  = CPTAxisLabelingPolicyAutomatic;
	self.yAxis.orthogonalCoordinateDecimal	  = CPTDecimalFromFloat([[self minYValue] floatValue] - 50);  // where to draw the y axis (x=...)
	//	self.yAxis.minorTicksPerInterval           = 4;
	//	self.yAxis.preferredNumberOfMajorTicks	  = 8;
	self.yAxis.majorGridLineStyle              = majorGridLineStyle;
	self.yAxis.minorGridLineStyle              = minorGridLineStyle;
	self.yAxis.labelOffset                     = 10.0;
	self.yAxis.title                           = @"flux";
	self.yAxis.titleOffset                     = 20.0;
	//self.yAxis.constraints					  = [CPTConstraints constraintWithLowerOffset:0.0];
	
	// set up plot
	// -----------
	// Create a plot that uses the data source method
	CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	dataSourceLinePlot.identifier = kScatterPlot;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
	
	// Line style
	// ----------
	CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 1.0;
	lineStyle.miterLimit = 1.0;
	lineStyle.lineColor = [CPTColor greenColor];
	dataSourceLinePlot.dataLineStyle = lineStyle;
	
	self.dataColor = lineStyle.lineColor.nsColor;
	
	dataSourceLinePlot.dataSource = self;
	[self.graph addPlot:dataSourceLinePlot];
	
	// Set plot delegate, to know when symbols have been touched
	// We will display an annotation when a symbol is touched
	dataSourceLinePlot.delegate = self;
	dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
	
	/*
	 CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	 [xRange expandRangeByFactor:CPTDecimalFromDouble(0.75)];
	 plotSpace.xRange = xRange;
	 CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
	 [yRange expandRangeByFactor:CPTDecimalFromDouble(0.75)];
	 plotSpace.yRange = yRange;
	 
	 CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(10.0)];
	 plotSpace.globalXRange = globalXRange;
	 CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-5.0) length:CPTDecimalFromDouble(10.0)];
	 plotSpace.globalYRange = globalYRange;
	 */
	// Title
	/*
	 CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	 textStyle.color = [CPTColor whiteColor];
	 textStyle.fontSize = 18.0f;
	 textStyle.fontName = @"Helvetica";
	 graph.title = @"BOSS Spectrum";
	 graph.titleTextStyle = textStyle;
	 graph.titleDisplacement = CGPoint{0.0f, -20.0f};
	 */
    // Setup scatter plot space
    //CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	//[plotSpace scaleToFitPlots:<#(NSArray *)#>
    //plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay*5.0f)];
    //plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(3.0)];
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
	plotSpace.delegate = self;
	plotSpace.allowsUserInteraction = YES;
	[plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSourceLinePlot]];

#pragma mark set up observers
	
	for (NSString *property in [self propertiesToObserve]) {
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}

}

- (NSArray*)propertiesToObserve
{
	return @[@"graphTitleDisplacementX", @"graphTitleDisplacementY", @"graph.titleDisplacement",
			 @"titleColor", @"dataColor",
			 @"borderLineWidth", @"borderLineColor"];
}

- (void)dealloc
{
	for (NSString *property in [self propertiesToObserve])
		[self removeObserver:self forKeyPath:property];
}

- (NSNumber*)minYValue
{
	//	return [self.wavelengths valueForKeyPath:@"@min.x"];
	NSNumber *minValue = [self.xData objectAtIndex:0];
	for (NSNumber *n in self.xData)
		if ([n floatValue] < [minValue floatValue])
			minValue = n;
	
	NSLog(@"min: %@", minValue);
	return minValue;
	
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	if ([(NSString*)[plot identifier] isEqualToString:kScatterPlot])
		return [self.xyData count];
	else {
		NSLog(@"[%@].%s: Identifier not found!!", [self class], __PRETTY_FUNCTION__);
		return 0;
	}
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
					 field:(NSUInteger)fieldEnum
			   recordIndex:(NSUInteger)index
{
	if ([(NSString*)[plot identifier] isEqualToString:kScatterPlot]) {
		NSNumber *n = (fieldEnum == CPTScatterPlotFieldX) ? [self.xData objectAtIndex:index]
														  : [self.yData objectAtIndex:index];
		
		//NSLog(@"asking for data point: %@", n);
		return n;
	}
	else {
		NSLog(@"[%@].%s: Identifier not found!!", self, __PRETTY_FUNCTION__);
		return [NSNumber numberWithInt:0];
	}
	
	
}

#pragma mark -

- (IBAction)changeTheme:(id)sender
{
	NSString *themeName = themePopup.titleOfSelectedItem;
	[self.graph applyTheme:[CPTTheme themeNamed:themeName]];
	
	// Most themes reset the axis labelling policy, so these need to be reset after changing themes.
	((CPTXYAxisSet*)self.graph.axisSet).xAxis.labelingPolicy = xAxisLabellingPolicyPopup.selectedItem.tag;
	((CPTXYAxisSet*)self.graph.axisSet).yAxis.labelingPolicy = yAxisLabellingPolicyPopup.selectedItem.tag;
}

- (IBAction)changeGraphTitleFont:(id)sender
{
	CPTMutableTextStyle *textStyle = [self.graph.titleTextStyle mutableCopy];
	textStyle.fontName = ((NSPopUpButton*)sender).titleOfSelectedItem;
	self.graph.titleTextStyle = textStyle;
}

- (IBAction)axisPolicyChanged:(id)sender
{
	NSPopUpButton *popup = sender;
	if (popup == xAxisLabellingPolicyPopup)
		self.xAxis.labelingPolicy = popup.selectedItem.tag;
	else
		self.yAxis.labelingPolicy = popup.selectedItem.tag;
	//[self.graph reloadData];
}

- (IBAction)changeTitleAnchorStyle:(id)sender
{
	self.graph.titlePlotAreaFrameAnchor = [(NSPopUpButton*)sender selectedItem].tag;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@", change);

	if ([keyPath isEqualToString:@"graphTitleDisplacementX"]) {
		CGFloat y = self.graph.titleDisplacement.y; // current value
		self.graph.titleDisplacement = (CGPoint){ self.graphTitleDisplacementX, y };
	
	} else if ([keyPath isEqualToString:@"graphTitleDisplacementY"]) {
		CGFloat x = self.graph.titleDisplacement.x; // current value
		self.graph.titleDisplacement = (CGPoint){ x, self.graphTitleDisplacementY };

	} else if ([keyPath isEqualToString:@"graph.titleDisplacement"]) {
		_graphTitleDisplacementX = self.graph.titleDisplacement.x;
		_graphTitleDisplacementY = self.graph.titleDisplacement.y;
	
	} else if ([keyPath isEqualToString:@"titleColor"]) {
		CPTMutableTextStyle *textStyle = [self.graph.titleTextStyle mutableCopy];
		textStyle.color = [CPTColor colorWithCGColor:self.titleColor.CGColor];
		self.graph.titleTextStyle = textStyle;

	} else if ([keyPath isEqualToString:@"dataColor"]) {
		CPTScatterPlot *plot = (CPTScatterPlot*)[self.graph plotWithIdentifier:kScatterPlot];
		CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
		lineStyle.lineColor = [CPTColor colorWithCGColor:self.dataColor.CGColor];
		plot.dataLineStyle = lineStyle; // this sets needsDisplay to YES
	
	} else if ([keyPath isEqualToString:@"borderLineWidth"]) {
		CPTMutableLineStyle *borderLineStyle = [self.graph.plotAreaFrame.borderLineStyle mutableCopy];
		borderLineStyle.lineWidth = self.borderLineWidth;
		self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
	
	} else if ([keyPath isEqualToString:@"borderLineColor"]) {
		CPTMutableLineStyle *borderLineStyle = [self.graph.plotAreaFrame.borderLineStyle mutableCopy];
		borderLineStyle.lineColor = [CPTColor colorWithCGColor:self.borderLineColor.CGColor];
		self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
		
	} else {
		NSLog(@"Uncaught keyPath observed: %@", keyPath);
	}
}

#pragma mark -
#pragma mark NSTextViewDelegate methods

//- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number
		
		CGFloat delta = command == @selector(moveUp:) ? +1. : -1.;
		
		
		CPTMutableTextStyle *textStyle;
		
		switch (control.tag) {
			case GRAPH_BORDER_LINE_WIDTH:
				self.borderLineWidth += delta;
				return YES;
				break;
			case GRAPH_TITLE_SIZE:
				// this acts weird at the extremes
				textStyle = [self.graph.titleTextStyle mutableCopy];
				if (self.graph.titleTextStyle.fontSize >= 7.0 || delta == +1.0)  { // min size: 6pt
					//self.graph.titleTextStyle = [CPTMutableTextStyle textStyleWithFontDelta:delta fromTextStyle:self.graph.titleTextStyle];
					textStyle.fontSize += delta;
				} else {
					//self.graph.titleTextStyle = [CPTMutableTextStyle textStyleWithFontSize:6 fromTextStyle:self.graph.titleTextStyle];
					textStyle.fontSize = 6.0;
				}
				self.graph.titleTextStyle = textStyle; // triggers draw
				return YES;
				break;
				
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


@end
