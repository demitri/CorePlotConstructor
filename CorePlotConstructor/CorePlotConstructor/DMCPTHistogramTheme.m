//
//  DMCPTHistogramTheme.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/16/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMCPTHistogramTheme.h"
#import "DMCorePlotUtilities.h"

//NSString *const kCPTPlainWhiteTheme = @"CocoaFITS Histogram";

@implementation DMCPTHistogramTheme

-(instancetype)init
{
	if ( (self = [super init]) ) {
		self.graphClass = [CPTXYGraph class];
	}
	return self;
}

+(void)load
{
	[self registerTheme:self];
}

+(NSString *)name
{
	//return kCPTPlainWhiteTheme;
	return @"CocoaFITS Histogram";
}

#pragma mark -
#pragma mark CPTTheme protocol methods

- (void)applyThemeToAxisSet:(CPTAxisSet *)axisSet
{
	// -----------
//	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)xyGraph.axisSet;
	CPTXYAxis *xAxis = [(CPTXYAxisSet *)axisSet xAxis];
	CPTXYAxis *yAxis = [(CPTXYAxisSet *)axisSet yAxis];
	
	// get data - property is assumed - this is my custom unoffical protocol
	//NSArray *xData = //[dataSource performSelector:@selector(xData)];
	//NSArray *yData = //[dataSource performSelector:@selector(yData)];
	
	// set up default range of x,y axes based on data
	NSArray *xMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.xData]
																	 ticks:0];
	NSArray *yMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.yData]
																	 ticks:0];
	
	xAxis.majorIntervalLength = @([xMajorTickLocations[1] doubleValue] - [xMajorTickLocations[0] doubleValue]); // yeeesh
	yAxis.majorIntervalLength = @([yMajorTickLocations[1] doubleValue] - [yMajorTickLocations[0] doubleValue]);
	
	xAxis.orthogonalPosition = yMajorTickLocations[0];
	yAxis.orthogonalPosition = xMajorTickLocations[0];
	
	xAxis.minorTicksPerInterval = 5;
	yAxis.minorTicksPerInterval = 5;

}

- (void) applyThemeToBackground:(CPTGraph *)graph
{
	// Set plot range displayed
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:self.xMajorTickLocations[0]
													length:@([self.xMajorTickLocations.lastObject floatValue] - [self.xMajorTickLocations.firstObject floatValue])];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:self.yMajorTickLocations[0]
													length:@([self.yMajorTickLocations.lastObject floatValue] - [self.yMajorTickLocations.firstObject floatValue])];
	
}

- (void) applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{
	
}

/*
 -(id)newGraph
 {
	CPTXYGraph *graph;
	
	if ( self.graphClass ) {
 graph = [[self.graphClass alloc] initWithFrame:CPTRectMake(0.0, 0.0, 200.0, 200.0)];
	}
	else {
 graph = [[CPTXYGraph alloc] initWithFrame:CPTRectMake(0.0, 0.0, 200.0, 200.0)];
	}
	graph.paddingLeft   = CPTFloat(60.0);
	graph.paddingTop    = CPTFloat(60.0);
	graph.paddingRight  = CPTFloat(60.0);
	graph.paddingBottom = CPTFloat(60.0);
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@(-1.0) length:@1.0];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@(-1.0) length:@1.0];
	
	[self applyThemeToGraph:graph];
	
	return graph;
 }
 */


#pragma mark -

- (NSMutableArray*)xMajorTickLocations
{
	if (_xMajorTickLocations == nil) {
		_xMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.xData] ticks:0];
	}
	return _xMajorTickLocations;
}

- (NSMutableArray*)yMajorTickLocations
{
	if (_yMajorTickLocations == nil) {
		_yMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.yData] ticks:0];
	}
	return _yMajorTickLocations;
}

#pragma mark -
#pragma mark NSCoding Methods

-(Class)classForCoder
{
	return [CPTTheme class];
}

@end
