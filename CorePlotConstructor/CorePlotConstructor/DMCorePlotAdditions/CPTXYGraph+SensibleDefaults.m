//
//  CPTXYGraph+SensibleDefaults.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/10/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPTXYGraph+SensibleDefaults.h"
#import <math.h>

#define MINIMUM_INTERVAL_SPACING 50 // pixels

@implementation CPTXYGraph (SensibleDefaults)
/*
- (void)setupDefaultIntervalsWithXRange:(NSArray*)xRange andYRange:(NSArray*)yRange
{
	//CPTXYGraph *graph = (CPTXYGraph*)self.graph;
	
	// set up X intervals
	// ------------------
	//CGFloat graphWidth = graph.frame.size.width;
	unsigned short nTicks = 5; //floor(graphWidth); // desired number of tick marks
	
	CGFloat xmin = [xRange[0] doubleValue];
	CGFloat xmax = [xRange[1] doubleValue];
	
	CGFloat range = [self _niceNumber:xmax-xmin round:false];
	CGFloat d = [self _niceNumber:range/(nTicks-1) round:true]; // step size
	CGFloat graphMin = floor(xmin/d) * d;
	CGFloat graphMax = ceil((xmax)/d) * d;
	CGFloat nFrac; // number of fractional digits to show
 
	nFrac = (-floor(log10(d)) > 0) ? -floor(log10(d)) : 0.0; 	// TODO: find macro
	CGFloat x = graphMin;
	while (x < graphMax + 0.5 * d) {
		DLog(@"%@", @(x));
		x += d;
	}

	self.xRange = [CPTPlotRange plotRangeWithLocation:@(graphMin) length:@(graphMax-graphMin)];
	
	// Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)newGraph.axisSet;
	CPTXYAxis *x          = axisSet.xAxis;
	x.majorIntervalLength   = @(oneDay);
	x.orthogonalPosition    = @2.0;
	x.minorTicksPerInterval = 3;

	// set up Y intervals
	// ------------------
	CGFloat ymin = [yRange[0] doubleValue];
	CGFloat ymax = [yRange[1] doubleValue];
	
	range = [self _niceNumber:ymax-ymin round:FALSE];
	d = [self _niceNumber:range/(nTicks-1) round:TRUE];
	graphMin = floor(ymin/d) * d;
	graphMax = ceil((ymax)/d) * d;
	nFrac = (-floor(log10(d)) > 0) ? -floor(log10(d)) : 0.0;
	CGFloat y = graphMin;
	while (y < graphMax + 0.5 * d) {
		DLog(@"%@", @(y));
		y += d;
	}
	
	self.yRange = [CPTPlotRange plotRangeWithLocation:@(graphMin) length:@(graphMax-graphMin)];

}
*/

#define mark Private methods

// nicenum: find a “nice” number approximately equal to x.
// Round the number if round = true, take ceiling if round = false.
+ (CGFloat)_niceNumber:(CGFloat)x round:(BOOL)round
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
