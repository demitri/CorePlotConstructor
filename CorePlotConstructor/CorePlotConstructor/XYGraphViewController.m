//
//  XYGraphViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 10/12/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "XYGraphViewController.h"
//#import "ContinuousBindingFixNumberFormatter.h"
#import <CorePlotInspectorFramework/CorePlotInspectorFramework.h>

#pragma mark -

@interface XYGraphViewController ()

- (void)initialize;

@end

#pragma mark -

@implementation XYGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self initialize];
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	[self initialize];
	return self;
}

- (void)initialize
{
	
}

- (void)awakeFromNib
{
//	ContinuousBindingFixNumberFormatter *f = [[ContinuousBindingFixNumberFormatter alloc] init];
//	f.usesSignificantDigits = NO;
//	f.maximumFractionDigits = 1;
//	f.minimumFractionDigits = 0;
//	titleSizeTextField.formatter = f;
	
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

	[self createGraph];
	
	self.plot = [[self.graph allPlots] objectAtIndex:0];
	
	// load and initialize inspector
	self.inspectorWindowController = [[CPIInspectorWindowController alloc] initWithGraph:self.graph];
	[self.inspectorWindowController.window makeKeyAndOrderFront:nil];

	// update UI items from graph
	// TODO
//	self.titleColor =  self.graph.titleTextStyle.color.nsColor;
//	self.graphTitleDisplacementX = self.graph.titleDisplacement.x;
//	self.graphTitleDisplacementY = self.graph.titleDisplacement.y;


}

- (void)createGraph2
{
	CGRect bounds = NSRectToCGRect(self.graphView.bounds);
	self.graph = [[CPTXYGraph alloc] initWithFrame:bounds];

	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
	[self.graph applyTheme:theme];
	self.graphView.hostedGraph = self.graph;
	
	CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	dataSourceLinePlot.delegate = self;
	dataSourceLinePlot.dataSource = self;
	dataSourceLinePlot.identifier = kScatterPlot;
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;

	[self.graph addPlot:dataSourceLinePlot];

	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
	plotSpace.delegate = self;
	plotSpace.allowsUserInteraction = YES;
	[plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSourceLinePlot]];

}

- (void)createGraph
{
	// ===========
	// Setup graph
	// ===========
	
	// ------------
	// Create graph
	// ------------
	CGRect bounds = NSRectToCGRect(self.graphView.bounds);
	self.graph = [[CPTXYGraph alloc] initWithFrame:bounds];
	
	// TODO: when graph is separated out, move this to the appropriate place.
/*	[self.graph addObserver:self
				 forKeyPath:@"titleDisplacement"
					options:NSKeyValueObservingOptionNew
					context:nil];
*/
	
	// -----------
	// apply theme
	// -----------
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
	[self.graph applyTheme:theme];
	self.graphView.hostedGraph = self.graph;
	
	// -----------
	// graph title
	// -----------
#pragma mark set up graph title
	self.graph.title = @"CPTXYGraph Plot Title";
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.color = [CPTColor grayColor];
	textStyle.fontName = @"Helvetica-Bold"; //kInitialFont; // @"Helvetica-Bold";
	textStyle.fontSize = 18.0;
	self.graph.titleTextStyle = textStyle;
	//	graph.titleDisplacement = CGPoint{0.0, 10.0};
	self.graph.titleDisplacement = (CGPoint){ 0.0f, round(bounds.size.height / (CGFloat)18.0) }; // Ensure that title displacement falls on an integral pixel
	self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	// TODO: check this works : [graphTitleFrameAnchorPopup selectItemWithTag:CPTRectAnchorTop];

	// ------------
	// graph border
	// ------------
#pragma mark set up graph border
	CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor = [CPTColor blackColor];
	borderLineStyle.lineWidth = 1.0;
	self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
	
	// -------------
	// Graph padding
	// -------------
	//    * how much to inset the x/y region (plot space) from the view
	//			e.g. to make room for labels
	//	  * default value in each direction: 20 pixels
	//	  * plot axis labels will not be drawn in this area
	//
	/*
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
	*/
	self.graph.paddingTop = 40;
	
	self.graph.plotAreaFrame.paddingTop	   = 15.0;
	self.graph.plotAreaFrame.paddingRight  = 10.0;
	self.graph.plotAreaFrame.paddingBottom = 55.0;
	self.graph.plotAreaFrame.paddingLeft   = 70.0;
	
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
	self.xAxis.axisConstraints					= [CPTConstraints constraintWithLowerOffset:0.0];
	
	// Label y with an automatic label policy.
	self.yAxis = axisSet.yAxis;
	self.yAxis.labelingPolicy                  = CPTAxisLabelingPolicyAutomatic;
	self.yAxis.orthogonalCoordinateDecimal	  = CPTDecimalFromFloat(self.minYValue.floatValue);// - 50);  // where to draw the y axis (x=...)
	//	self.yAxis.minorTicksPerInterval           = 4;
	//	self.yAxis.preferredNumberOfMajorTicks	  = 8;
	self.yAxis.majorGridLineStyle              = majorGridLineStyle;
	self.yAxis.minorGridLineStyle              = minorGridLineStyle;
	self.yAxis.labelOffset                     = 10.0;
	self.yAxis.title                           = @"flux";
	self.yAxis.titleOffset                     = 50.0;
	self.yAxis.axisConstraints				   = [CPTConstraints constraintWithLowerOffset:20.0];
	
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
}

- (NSNumber*)minYValue
{
	//	return [self.wavelengths valueForKeyPath:@"@min.x"];
	NSNumber *minValue = [self.xData objectAtIndex:0];
	for (NSNumber *n in self.xData)
		if ([n floatValue] < [minValue floatValue])
			minValue = n;
	
	//NSLog(@"min: %@", minValue);
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



@end
