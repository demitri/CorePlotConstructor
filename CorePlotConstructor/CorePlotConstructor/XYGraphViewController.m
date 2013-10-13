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

@interface XYGraphViewController ()

@end

@implementation XYGraphViewController

@synthesize graph, graphView;
@synthesize xData, yData, xyData;
@synthesize graphTitleDisplacementX, graphTitleDisplacementY;

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
	
	for (unsigned int i=0; i < [yData count]; i++) {
		[self.xyData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self.yData objectAtIndex:i], @"y",
									  [self.xData objectAtIndex:i], @"x", nil]];
	}
	
	// ===============
	// Setup inspector
	// ===============
	[themePopup removeAllItems];
    for ( Class c in [CPTTheme themeClasses] )
        [themePopup addItemWithTitle:[c name]];
	[themePopup selectItemWithTitle:kCPTPlainWhiteTheme];
	
	[xAxisLabellingPolicyPopup removeAllItems];
	[yAxisLabellingPolicyPopup removeAllItems];
	NSArray *policyArray = @[@"CPTAxisLabelingPolicyNone", @"CPTAxisLabelingPolicyLocationsProvided",
							 @"CPTAxisLabelingPolicyFixedInterval",
							 @"CPTAxisLabelingPolicyAutomatic", @"CPTAxisLabelingPolicyEqualDivisions"];
	for (NSString *policy in policyArray) {
		[xAxisLabellingPolicyPopup addItemWithTitle:policy];
		[yAxisLabellingPolicyPopup addItemWithTitle:policy];
	}
	
	// fonts
	[graphTitleFontPopup removeAllItems];
	for (NSString *fontName in [[NSFontManager sharedFontManager] availableFontFamilies])
		[graphTitleFontPopup addItemWithTitle:fontName];
	[graphTitleFontPopup selectItemWithTitle:kInitialFont];
	
	[graphTitleFrameAnchorPopup removeAllItems];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorBottomLeft"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorBottom"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorBottomRight"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorLeft"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorRight"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorTopLeft"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorTop"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorRight"];
	[graphTitleFrameAnchorPopup addItemWithTitle:@"CPTRectAnchorCenter"];
	
	for (int i=0; i < graphTitleFrameAnchorPopup.menu.numberOfItems - 1; i++)
		[graphTitleFrameAnchorPopup itemAtIndex:i].representedObject = [NSNumber numberWithInt:i];

	[self addObserver:self
		   forKeyPath:@"graphTitleDisplacementX"
			  options:NSKeyValueObservingOptionNew
			  context:nil];

	[self addObserver:self
		   forKeyPath:@"graphTitleDisplacementY"
			  options:NSKeyValueObservingOptionNew
			  context:nil];

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
	graphView.hostedGraph = self.graph;
	
	// -----------
	// graph title
	// -----------
	self.graph.title = @"CPTXYGraph Plot Title";
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color = [CPTColor grayColor];
	textStyle.fontName = kInitialFont; // @"Helvetica-Bold";
	textStyle.fontSize = 18.0;
	//	textStyle.fontSize = round(bounds.size.height / (CGFloat)20.0);
	self.graph.titleTextStyle = textStyle;
	//	graph.titleDisplacement = CGPointMake(0.0, 10.0);
	self.graph.titleDisplacement = CGPointMake( 0.0f, round(bounds.size.height / (CGFloat)18.0) ); // Ensure that title displacement falls on an integral pixel
	self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	
	self.graphTitleDisplacementX = self.graph.titleDisplacement.x;
	self.graphTitleDisplacementY = self.graph.titleDisplacement.y;
	
	// ------------
	// graph border
	// ------------
	//CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
	//borderLineStyle.lineColor = [CPTColor whiteColor];
	//borderLineStyle.lineWidth = 1.0;
	//graph.plotAreaFrame.borderLineStyle = borderLineStyle;
	
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
		self.graph.paddingTop = graph.titleDisplacement.y * 2;
	}
	else {
		self.graph.paddingTop = boundsPadding;
	}
	
	self.graph.paddingRight	= boundsPadding;
	self.graph.paddingBottom = boundsPadding;
	
	self.graph.plotAreaFrame.paddingTop	  = 15.0;
	self.graph.plotAreaFrame.paddingRight  = 15.0;
	self.graph.plotAreaFrame.paddingBottom = 55.0;
	self.graph.plotAreaFrame.paddingLeft	  = 55.0;
	
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
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 0.75;
	majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
	
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 0.25;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
	
	// ====
	// Axes
	// ====
	// Label x axis with a fixed interval policy
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
	CPTXYAxis *x					  = axisSet.xAxis;
	x.labelingPolicy                  = CPTAxisLabelingPolicyAutomatic;
	x.orthogonalCoordinateDecimal	  = CPTDecimalFromUnsignedInteger(0); // where to draw the x axis (y=...)
	//	x.minorTicksPerInterval           = 4;
	//	x.preferredNumberOfMajorTicks	  = 8;
	x.majorGridLineStyle              = majorGridLineStyle;
	x.minorGridLineStyle              = minorGridLineStyle;
	x.title                           = @"wavelengths";
	x.titleOffset                     = 20.0;
	NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
	labelFormatter.numberStyle = NSNumberFormatterNoStyle; // NSNumberFormatterScientificStyle
	x.labelFormatter		   = labelFormatter;
	
	// Label y with an automatic label policy.
	CPTXYAxis *y = axisSet.yAxis;
	y.labelingPolicy                  = CPTAxisLabelingPolicyAutomatic;
	y.orthogonalCoordinateDecimal	  = CPTDecimalFromFloat([[self minYValue] floatValue] - 50);  // where to draw the y axis (x=...)
	//	y.minorTicksPerInterval           = 4;
	//	y.preferredNumberOfMajorTicks	  = 8;
	y.majorGridLineStyle              = majorGridLineStyle;
	y.minorGridLineStyle              = minorGridLineStyle;
	y.labelOffset                     = 10.0;
	y.title                           = @"flux";
	y.titleOffset                     = 20.0;
	//y.constraints					  = [CPTConstraints constraintWithLowerOffset:0.0];
	
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
	 graph.titleDisplacement = CGPointMake(0.0f, -20.0f);
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
		return [xyData count];
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
}

- (IBAction)changeGraphTitleFont:(id)sender
{
	((CPTMutableTextStyle *)self.graph.titleTextStyle).fontName = ((NSPopUpButton*)sender).titleOfSelectedItem;
	[self.graph reloadData];
}

- (IBAction)axisPolicyChanged:(id)sender
{
	CPTXYAxis *axis;
	if (sender == xAxisLabellingPolicyPopup)
		axis = ((CPTXYAxisSet*)self.graph.axisSet).xAxis;
	else
		axis = ((CPTXYAxisSet*)self.graph.axisSet).xAxis;
	
	NSString *policy = [(NSPopUpButton*)sender titleOfSelectedItem];
	if ([policy isEqualToString:@"CPTAxisLabelingPolicyNone"])
		axis.labelingPolicy = CPTAxisLabelingPolicyNone;
	else if ([policy isEqualToString:@"CPTAxisLabelingPolicyLocationsProvided"])
		axis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
	else if ([policy isEqualToString:@"CPTAxisLabelingPolicyFixedInterval"])
		axis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
	else if ([policy isEqualToString:@"CPTAxisLabelingPolicyAutomatic"])
		axis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	else if ([policy isEqualToString:@"CPTAxisLabelingPolicyEqualDivisions  "])
		axis.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions  ;
	
	[self.graph reloadData];
}

- (IBAction)changeTitleAnchorStyle:(id)sender
{
	NSString *style = ((NSPopUpButton*)sender).titleOfSelectedItem;
	if ([style isEqualToString:@"CPTRectAnchorBottomLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomLeft;
	else if ([style isEqualToString:@"CPTRectAnchorBottom"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottom;
	else if ([style isEqualToString:@"CPTRectAnchorBottomRight"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomRight;
	else if ([style isEqualToString:@"CPTRectAnchorLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorLeft;
	else if ([style isEqualToString:@"CPTRectAnchorRight"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorRight;
	else if ([style isEqualToString:@"CPTRectAnchorBottomLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomLeft;
	else if ([style isEqualToString:@"CPTRectAnchorBottomLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomLeft;
	else if ([style isEqualToString:@"CPTRectAnchorBottomLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomLeft;
	else if ([style isEqualToString:@"CPTRectAnchorBottomLeft"])
		graph.titlePlotAreaFrameAnchor = CPTRectAnchorBottomLeft;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"graphTitleDisplacementX"]) {
		CGFloat y = self.graph.titleDisplacement.y; // current value
		self.graph.titleDisplacement = CGPointMake( self.graphTitleDisplacementX, round(self.graph.bounds.size.height / y) );
	} else if ([keyPath isEqualToString:@"graphTitleDisplacementY"]) {
		CGFloat x = self.graph.titleDisplacement.x; // current value
		self.graph.titleDisplacement = CGPointMake( x, round(self.graph.bounds.size.height / graphTitleDisplacementY) );
	} else {
		NSLog(@"Uncaught keyPath observed: %@", keyPath);
	}
}

@end
