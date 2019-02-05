//
//  DMCorePlotUtilities.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/10/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMCorePlotUtilities.h"

#define DEFAULT_TICK_COUNT 5

float niceNumber(CGFloat x, int round);

@implementation DMCorePlotUtilities

+ (void)setupXYGraph:(CPTXYGraph*)xyGraph withDataSource:(id<CPTPlotDataSource>)dataSource andDelegate:(id<CPTPlotSpaceDelegate>)delegate
{
	// set up scatter plot
	CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
	dataSourceLinePlot.delegate = delegate;
	dataSourceLinePlot.dataSource = dataSource;
	dataSourceLinePlot.identifier = @"scatter plot";
	dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
	[xyGraph addPlot:dataSourceLinePlot];
	
	xyGraph.plotAreaFrame.masksToBorder = NO;
	
	// remove border
	CPTMutableLineStyle *borderLineStyle = [[CPTMutableLineStyle alloc] init];
	borderLineStyle.lineWidth = 0;
	xyGraph.borderLineStyle = borderLineStyle;

	// set up plot space
	// -----------------
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)xyGraph.defaultPlotSpace;
	plotSpace.delegate = delegate;
	plotSpace.allowsUserInteraction = YES;
	[plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSourceLinePlot]];

	// set up axes
	// -----------
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)xyGraph.axisSet;
	CPTXYAxis *xAxis = axisSet.xAxis;
	CPTXYAxis *yAxis = axisSet.yAxis;

	// get data - property is assumed - this is my custom unoffical protocol
	NSArray *xData = [dataSource performSelector:@selector(xData)];
	NSArray *yData = [dataSource performSelector:@selector(yData)];

	// set up default range of x,y axes based on data
	NSArray *xMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:xData]
																	ticks:0];
	NSArray *yMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:yData]
																	 ticks:0];

	xAxis.majorIntervalLength = @([xMajorTickLocations[1] doubleValue] - [xMajorTickLocations[0] doubleValue]); // yeeesh
	yAxis.majorIntervalLength = @([yMajorTickLocations[1] doubleValue] - [yMajorTickLocations[0] doubleValue]);
	
	xAxis.orthogonalPosition = yMajorTickLocations[0];
	yAxis.orthogonalPosition = xMajorTickLocations[0];
	
	xAxis.minorTicksPerInterval = 5;
	yAxis.minorTicksPerInterval = 5;

	// Set plot range displayed
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:xMajorTickLocations[0]
													length:@([xMajorTickLocations.lastObject floatValue] - [xMajorTickLocations.firstObject floatValue])];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:yMajorTickLocations[0]
													length:@([yMajorTickLocations.lastObject floatValue] - [yMajorTickLocations.firstObject floatValue])];
	
	// set padding
	// -----------
	//xyGraph.paddingLeft = 60;
	//xyGraph.paddingBottom = 60;
	CGFloat axisLabelSize = 12.0;
	xyGraph.plotAreaFrame.paddingLeft += axisLabelSize * CPTFloat(2.25);
	xyGraph.plotAreaFrame.paddingBottom += axisLabelSize * CPTFloat(2.25);

	// Restrict y range to a global range
	// ----------------------------------
	CGFloat xMid = [xMajorTickLocations.lastObject floatValue] - [xMajorTickLocations[0] floatValue];
	CGFloat yMid = [yMajorTickLocations.lastObject floatValue] - [yMajorTickLocations[0] floatValue];
	CGFloat ymin = [yMajorTickLocations[0] floatValue] - 0.5 * yMid;
	CGFloat ymax = [yMajorTickLocations.lastObject floatValue] + 0.5 * yMid;
	CGFloat xmin = [xMajorTickLocations[0] floatValue] - 0.5 * xMid;
	CGFloat xmax = [xMajorTickLocations.lastObject floatValue] + 0.5 * xMid;
	CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:@(ymin)
															  length:@(ymax - ymin)];
	CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:@(xmin)
															  length:@(xmax - xmin)];
	plotSpace.globalYRange = globalYRange;
	plotSpace.globalXRange = globalXRange;

	// Constraints
	xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	
	// ---
	
	//[plotSpace setupDefaultIntervalsWithXRange:[DMCorePlotUtilities minMax:self.xData]
	//								 andYRange:[DMCorePlotUtilities minMax:self.yData]];
	

}

+ (NSArray*)niceRangeForValues:(NSArray*)values ticks:(NSInteger)noTicks
{
	// Returns an array of major tick locations given 
	//
	NSMutableArray *tickLocations = [NSMutableArray array];
	
	if (noTicks == 0)
		noTicks = DEFAULT_TICK_COUNT; // set default value
	
	CGFloat min = [values[0] doubleValue];
	CGFloat max = [values[1] doubleValue];
	
	CGFloat range = niceNumber(max-min, false);
	CGFloat d = niceNumber(range/(noTicks-1), true); // step size
	CGFloat graphMin = floor(min/d) * d;
	CGFloat graphMax = ceil((max)/d) * d;
	CGFloat nFrac; // number of fractional digits to show
 
	nFrac = (-floor(log10(d)) > 0) ? -floor(log10(d)) : 0.0; 	// TODO: find macro
	CGFloat x = graphMin;
	while (x < graphMax + 0.5 * d) {
		//DLog(@"%@", @(x));
		[tickLocations addObject:@(x)];
		x += d;
	}
	
	return tickLocations;
}

/*
 This function takes an array of NSNumber values and returns
 the minimum and maximum values in a two element array.
 */
+ (NSArray*)minMax:(NSArray*)values
{
	NSAssert(values != nil, @"values not set");
	
	NSUInteger minIdx = 0;
	NSUInteger maxIdx = minIdx;
	CGFloat minValue = [values[0] doubleValue];
	CGFloat maxValue = [values[0] doubleValue];
	
	for (NSUInteger i=1; i < values.count; i++) {
		CGFloat v = [values[i] doubleValue];
		if (v < minValue) {
			minIdx = i;
			minValue = v;
		}
		if (v > maxValue) {
			maxIdx = i;
			maxValue = v;
		}
	}
	
	return @[[values[minIdx] copy], [values[maxIdx] copy]];
}

#define mark Private methods

// nicenum: find a “nice” number approximately equal to x.
// Round the number if round = true, take ceiling if round = false.
//+ (CGFloat)_niceNumber:(CGFloat)x round:(BOOL)round
float niceNumber(CGFloat x, int round)
{
	int exp;		// exponent of x
	CGFloat f;		// fractional part
	CGFloat nf;		// nice, rounded fraction
	
	exp = floor(log10(x));
	f = x / pow(10.0, exp);
	
	if (round) {
		if (f < 1.5)
			nf = 1.0;
		else if (f < 3.0)
			nf = 2.0;
		else if (f < 7.0)
			nf = 5.0;
		else
			nf = 10.0;
	} else {
		if (f <= 1.0)
			nf = 1.0;
		else if (f <= 2.0)
			nf = 2.0;
		else if (f <= 5.0)
			nf = 5.0;
		else
			nf = 10;
	}
	return nf * pow(10, exp);
}

@end
