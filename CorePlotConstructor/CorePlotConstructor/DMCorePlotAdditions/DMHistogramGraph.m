//
//  DMHistogramGraph.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMHistogramGraph.h"
#import "DMCorePlotUtilities.h"

@interface DMHistogramGraph ()

@end

#pragma mark -

@implementation DMHistogramGraph

- (void)initializeGraphWithXData:(NSArray *)xData yData:(NSArray *)yData
{
	[super initializeGraphWithXData:xData yData:yData];
	
	// set up bar plot
	// ---------------
	self.barPlot = [[CPTBarPlot alloc] init];
	self.barPlot.identifier = @"bar plot";
	self.barPlot.cachePrecision = CPTPlotCachePrecisionDouble;
	
	if (self.delegate)
		self.barPlot.delegate = self.delegate;
	if (self.dataSource)
		self.barPlot.dataSource = self.dataSource;
	[self addPlot:self.barPlot];
	
	// set up plot space properties
	// ----------------------------
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*)self.defaultPlotSpace;
	plotSpace.allowsUserInteraction = NO;
	[plotSpace scaleToFitPlots:@[self.barPlot]];
	
	
	
}


@end

