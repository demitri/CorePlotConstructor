//
//  DMScatterPlotGraph2.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMScatterPlotGraph2.h"
#import "DMCorePlotUtilities.h"

@interface DMScatterPlotGraph2 ()

@end

@implementation DMScatterPlotGraph2

- (void)initializeGraphWithXData:(NSArray*)xData yData:(NSArray*)yData
{
	[super initializeGraphWithXData:xData yData:yData];
	
	// set up scatter plot
	// -------------------
	self.scatterPlot = [[CPTScatterPlot alloc] init];
	self.scatterPlot.identifier = @"scatter plot";
	self.scatterPlot.cachePrecision = CPTPlotCachePrecisionDouble;

	if (self.delegate)
		self.scatterPlot.delegate = self.delegate;
	if (self.dataSource)
		self.scatterPlot.dataSource = self.dataSource;
	[self addPlot:self.scatterPlot];

	// set up plot space properties
	// ----------------------------
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
	plotSpace.allowsUserInteraction = self.allowsUserInteraction;
	[plotSpace scaleToFitPlots:@[self.scatterPlot]];

	self.xAxis.majorTickLength = 7.0;
	self.yAxis.majorTickLength = 7.0;
	self.xAxis.minorTickLength = 3.0;
	self.yAxis.minorTickLength = 3.0;

	[self updateDataX];
	[self updateDataY];

	// Restrict y range to a global range
	// ==================================
	CGFloat xMid = [self.xMajorTickLocations.lastObject floatValue] - [self.xMajorTickLocations[0] floatValue];
	CGFloat yMid = [self.yMajorTickLocations.lastObject floatValue] - [self.yMajorTickLocations[0] floatValue];
	CGFloat ymin = [self.yMajorTickLocations[0] floatValue] - 0.5 * yMid;
	CGFloat ymax = [self.yMajorTickLocations.lastObject floatValue] + 0.5 * yMid;
	CGFloat xmin = [self.xMajorTickLocations[0] floatValue] - 0.5 * xMid;
	CGFloat xmax = [self.xMajorTickLocations.lastObject floatValue] + 0.5 * xMid;
	CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:@(ymin)
															  length:@(ymax - ymin)];
	CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:@(xmin)
															  length:@(xmax - xmin)];
	
	plotSpace.globalYRange = globalYRange;
	plotSpace.globalXRange = globalXRange;

}

#pragma mark -

- (void)updateDataX
{
	DLog(@"");
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.axisSet;
	CPTXYAxis *xAxis = axisSet.xAxis;
	
	// set up default range of x axis based on data
	xAxis.majorIntervalLength = @([self.xMajorTickLocations[1] doubleValue] - [self.xMajorTickLocations[0] doubleValue]); // yeeesh
	xAxis.orthogonalPosition = self.yMajorTickLocations[0];
	xAxis.minorTicksPerInterval = 5;
	
	// Set plot range displayed
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@([self.xMajorTickLocations[0] floatValue] - 0.1)
													length:@([self.xMajorTickLocations.lastObject floatValue] - [self.xMajorTickLocations.firstObject floatValue] + 0.2)];
}

- (void)updateDataY
{
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.axisSet;
	CPTXYAxis *yAxis = axisSet.yAxis;
	
	NSArray *yTicks = self.yMajorTickLocations; // shorthand
	
	// set up default range of x axis based on data
	yAxis.majorIntervalLength = @([yTicks[1] doubleValue] - [yTicks[0] doubleValue]);
	yAxis.orthogonalPosition = self.xMajorTickLocations[0];
	yAxis.minorTicksPerInterval = 5;
	
	// Set plot range displayed
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:yTicks[0]
													length:@([yTicks.lastObject floatValue] - [yTicks.firstObject floatValue])];
}

- (NSArray*)xMajorTickLocations
{
	if (_xMajorTickLocations == nil) {
		_xMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.xData]
																 ticks:0];
	}
	return _xMajorTickLocations;
}

- (NSArray*)yMajorTickLocations
{
	if (_yMajorTickLocations == nil) {
		_yMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:self.yData]
																 ticks:0];
	}
	return _yMajorTickLocations;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	if (object == self) {
		if ([keyPath isEqualToString:@"delegate"]) {
			self.scatterPlot.delegate = self.delegate;
		}
		else if ([keyPath isEqualToString:@"dataSource"]) {
			self.scatterPlot.dataSource = self.dataSource;
		}
		else if ([keyPath isEqualToString:@"xData"]) {
			
			self.xMajorTickLocations = nil;
			[self updateDataX];
			[self updateXTitlePadding];
		}
		else if ([keyPath isEqualToString:@"yData"]) {
			
			self.yMajorTickLocations = nil;
			[self updateDataY];
			[self updateYTitlePadding];
		}
		else if ([keyPath isEqualToString:@"allowsUserInteraction"]) {
			
			CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
			plotSpace.allowsUserInteraction = self.allowsUserInteraction;
		}
		
	}
}


@end
