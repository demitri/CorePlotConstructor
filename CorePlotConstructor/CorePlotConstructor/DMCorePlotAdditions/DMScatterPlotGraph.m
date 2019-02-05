//
//  DMScatterPlotGraph.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/27/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMScatterPlotGraph.h"
#import "DMCorePlotUtilities.h"
#import "CPTMutableLineStyle+Copies.h"
#import "CPTTextStyle+Copies.h"

@interface DMScatterPlotGraph ()
@property (nonatomic, weak, readwrite) CPTXYAxis *xAxis;
@property (nonatomic, weak, readwrite) CPTXYAxis *yAxis;
- (void)commonInit;
- (void)updateDataX;
- (void)updateDataY;
- (NSArray*)observedProperties;
- (void)adjustTitlePadding;
- (NSArray*)axisPropertiesToObserve;
@end

#pragma mark

@implementation DMScatterPlotGraph

- (instancetype)initWithFrame:(CGRect)newFrame
{
	self = [super initWithFrame:newFrame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)newFrame xScaleType:(CPTScaleType)newXScaleType yScaleType:(CPTScaleType)newYScaleType
{
	// calls designated initializer above
	return [super initWithFrame:newFrame xScaleType:newXScaleType yScaleType:newYScaleType];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (NSArray*)observedProperties
{
	return @[@"delegate", @"dataSource", @"xData", @"yData",
			 @"allowsUserInteraction", @"title", @"titleTextStyle"];
}

- (NSArray*)axisPropertiesToObserve
{
	return 	@[@"labelTextStyle", @"titleTextStyle", @"axisLabels", @"title"];
}

- (void)commonInit
{
	// defaults
	// --------
	self.allowsUserInteraction = YES;

	for (NSString *property in [self observedProperties])
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
}

- (void)dealloc
{
	for (NSString *property in [self observedProperties])
		[self removeObserver:self forKeyPath:property];
	
	for (CPTAxis *axis in @[self.xAxis, self.yAxis])
		for (NSString *property in [self axisPropertiesToObserve])
			[axis removeObserver:self forKeyPath:property];
}

- (void)initializeGraph
{
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
	
	// set up plot space
	// -----------------
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
	if (self.delegate)
		plotSpace.delegate = self; //.delegate;
	plotSpace.allowsUserInteraction = self.allowsUserInteraction;
	[plotSpace scaleToFitPlots:[NSArray arrayWithObject:self.scatterPlot]];
	
	[self applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];

	// Graph Properties
	// ================
	self.plotAreaFrame.masksToBorder = NO;
	CPTMutableTextStyle *newTitleTextStyle = [CPTMutableTextStyle textStyleWithStyle:self.titleTextStyle];
	newTitleTextStyle.fontSize = 18;
	self.titleTextStyle = newTitleTextStyle;
	
	// remove border from both graph and plotAreaFrame
	// -----------------------------------------------
	CPTMutableLineStyle *graphBorderLineStyle = [[CPTMutableLineStyle alloc] init];
	graphBorderLineStyle.lineWidth = 1.0;
	self.borderLineStyle = graphBorderLineStyle;
	
	self.plotAreaFrame.borderLineStyle = nil;
	
	// set padding
	// -----------
	
	CPTMutableTextStyle *textStyle;

	// axis title text style
	textStyle = [[CPTMutableTextStyle alloc] init];
	textStyle.fontSize = 12;
	self.xAxis.titleTextStyle = textStyle;
	self.yAxis.titleTextStyle = textStyle;

	// axis labels text style
	textStyle = [[CPTMutableTextStyle alloc] init];
	textStyle.fontSize = 12;
	self.xAxis.labelTextStyle = textStyle;
	self.yAxis.labelTextStyle = textStyle;
	
	// padding: font size + 20
	//CGFloat axisLabelSize = 12.0; // default value
	self.plotAreaFrame.paddingLeft = self.yAxis.labelTextStyle.fontSize + self.yAxis.labelTextStyle.fontSize + 20.0;
	self.plotAreaFrame.paddingBottom = self.xAxis.labelTextStyle.fontSize + self.xAxis.labelTextStyle.fontSize + 20.0;

	[self updateYTitlePadding];
	[self updateXTitlePadding];
	
	NSAssert(_xData != nil && _yData != nil, @"data must be set before calling 'initializeGraph'");
	[self updateDataX];
	[self updateDataY];
	
	self.xAxis.majorTickLength = 7.0;
	self.yAxis.majorTickLength = 7.0;
	self.xAxis.minorTickLength = 3.0;
	self.yAxis.minorTickLength = 3.0;
	
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
	
	// Constraints
	self.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	self.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	
	// set up KVO after graph properties have been set
	for (CPTAxis *axis in @[self.xAxis, self.yAxis])
		for (NSString *property in [self axisPropertiesToObserve]) {
			[axis addObserver:self
						 forKeyPath:property
							options:NSKeyValueObservingOptionNew
							context:nil];
		}
/*	[self.xAxis addObserver:self
		   forKeyPath:@"labelTextStyle"
			   options:NSKeyValueObservingOptionNew
			   context:nil];
	[self.xAxis addObserver:self
		   forKeyPath:@"titleTextStyle"
					options:NSKeyValueObservingOptionNew
					context:nil];
	[self.yAxis addObserver:self
			forKeyPath:@"labelTextStyle"
			   options:NSKeyValueObservingOptionNew
			   context:nil];
	[self.yAxis addObserver:self
		   forKeyPath:@"titleTextStyle"
					options:NSKeyValueObservingOptionNew
					context:nil];
	[self.yAxis addObserver:self
				 forKeyPath:@"axisLabels"
					options:NSKeyValueObservingOptionNew
					context:nil];
*/
}

- (void)updateAxisLabelSize
{
	self.plotAreaFrame.paddingLeft = self.yAxis.labelTextStyle.fontSize + self.yAxis.labelTextStyle.fontSize + 20.0;
	self.plotAreaFrame.paddingBottom = self.xAxis.labelTextStyle.fontSize + self.xAxis.labelTextStyle.fontSize + 20.0;
}

- (void)updateYTitlePadding
{
	NSSize titleSize = NSMakeSize(0, 0);
	
	if (self.yAxis.axisTitle != nil) {
		CPTTextStyle *style = self.yAxis.titleTextStyle;
		NSFont *font = [NSFont fontWithName:style.fontName size:style.fontSize];
		titleSize = [self.yAxis.title sizeWithAttributes:@{NSFontAttributeName:font}];
	}
	
	CGFloat titleWidth = titleSize.height; // (rotated)
	
	// get width of widest onscreen label
	CGFloat maxLabelWidth = 0;
	for (CPTAxisLabel *label in self.yAxis.axisLabels) {
		if (maxLabelWidth < label.contentLayer.bounds.size.width)
			maxLabelWidth = label.contentLayer.bounds.size.width;
	}

	self.paddingLeft = (titleWidth > 0) ? titleWidth + (maxLabelWidth - 12) - 10.0 : (maxLabelWidth - 12) - 10.0;

	// ---------------
	
	// axis title offset
	//    - the y constant should be related to the estimated width of the labels
		
/*
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"offset"];
	animation.fromValue = @(self.yAxis.titleOffset);
	animation.toValue = @(maxWidth + 10);
	animation.duration = 2.0f;
	[self.yAxis.axisTitle.contentLayer addAnimation:animation forKey:animation.keyPath];
*/
	
	self.yAxis.titleOffset = maxLabelWidth + 10.0;
}

- (void)updateXTitlePadding
{
	NSSize titleSize = NSMakeSize(0, 0);
	
	if (self.xAxis.axisTitle != nil) {
		CPTTextStyle *style = self.xAxis.titleTextStyle;
		NSFont *font = [NSFont fontWithName:style.fontName size:style.fontSize];
		titleSize = [self.xAxis.title sizeWithAttributes:@{NSFontAttributeName:font}];
	}
	
	CGFloat titleHeight = titleSize.height;
	
	// get height of tallest onscreen label
	CGFloat maxLabelHeight = 0;
	for (CPTAxisLabel *label in self.xAxis.axisLabels) {
		if (maxLabelHeight < label.contentLayer.bounds.size.height)
			maxLabelHeight = label.contentLayer.bounds.size.height;
	}

	self.paddingBottom = (titleHeight > 0) ? titleHeight - 10.0 + (maxLabelHeight - 12): (maxLabelHeight - 12) - 10.0;
	
	// ---------------
	
	// axis title offset
	//    - the y constant should be related to the estimated width of the labels
	
	//	if (self.xAxis.axisTitle == nil)
	//		return;
	
	self.xAxis.titleOffset = maxLabelHeight + 5.0;
}

- (CPTAxis*)xAxis
{
	if (_xAxis == nil) {
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.axisSet;
		_xAxis = axisSet.xAxis;
	}
	return _xAxis;
}

- (CPTAxis*)yAxis
{
	if (_yAxis == nil) {
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.axisSet;
		_yAxis = axisSet.yAxis;
	}
	return _yAxis;
}

- (void)adjustTitlePadding
{
	CPTTextStyle *style = self.titleTextStyle;
	NSFont *font = [NSFont fontWithName:style.fontName size:style.fontSize];
	CGFloat titleHeight = [self.title sizeWithAttributes:@{NSFontAttributeName:font}].height;
	
	CGPoint currentDisplacement = self.titleDisplacement;

	// title displacement 0 = top of title below graph border
	self.titleDisplacement = CGPointMake(currentDisplacement.x, titleHeight + 10);
	self.paddingTop = titleHeight + 15;
}

#pragma mark -
#pragma mark data updated methods

- (void)setXData:(NSArray*)xData yData:(NSArray*)yData
{
	// For the first time, both data sets must be defined.
	// This avoids KVO from triggering the method below without one set being defined.
	_xData = xData;
	self.yData = yData;
}

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
#pragma mark CPTPlotSpaceDelegate

- (CPTPlotRange*)plotSpace:(nonnull CPTPlotSpace *)space willChangePlotRangeTo:(nonnull CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
	//return newRange;
	if (coordinate == CPTCoordinateX) {
		//self.xMajorTickLocations = nil; // reset
		//_xMajorTickLocations = [DMCorePlotUtilities niceRangeForValues:[DMCorePlotUtilities minMax:@[] ticks:0]];
		//self.xAxis.majorIntervalLength = @([self.xMajorTickLocations[1] doubleValue] - [self.xMajorTickLocations[0] doubleValue]); // yeeesh
		//self.xAxis.orthogonalPosition = self.yMajorTickLocations[0];
	}
	
	else if (coordinate == CPTCoordinateY) {
		;
	}
	
	DLog(@"");
	return newRange;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	if (object == self) {
		if ([keyPath isEqualToString:@"delegate"]) {
			self.scatterPlot.delegate = self.delegate;
			
			CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
			plotSpace.delegate = self.delegate;
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
		else if ([keyPath isEqualToString:@"title"]) {
			
			[self adjustTitlePadding];
		}
		else if ([keyPath isEqualToString:@"titleTextStyle"]) {
			[self adjustTitlePadding];
		}
		
	} else if (object == self.xAxis) {
		[self updateXTitlePadding];
		if ([keyPath isEqualToString:@"updateAxisLabelSize"])
			[self updateAxisLabelSize];
		
	} else if (object == self.yAxis) {
		[self updateYTitlePadding];
		if ([keyPath isEqualToString:@"updateAxisLabelSize"]) {
			[self updateAxisLabelSize];
		}
		else if ([keyPath isEqualToString:@"axisLabels"]) {
			[self updateXTitlePadding];
			[self updateYTitlePadding];
			//DLog(@"y axis labels: %@", self.yAxis.axisLabels);
		}
	}
}

@end
