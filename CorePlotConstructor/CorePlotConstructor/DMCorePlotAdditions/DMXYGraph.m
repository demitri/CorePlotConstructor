//
//  DMXYGraph.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMXYGraph.h"
#import "DMCorePlotUtilities.h"
#import "CPTMutableLineStyle+Copies.h"
#import "CPTTextStyle+Copies.h"

@interface DMXYGraph ()
@property (nonatomic, weak, readwrite) CPTXYAxis *xAxis;
@property (nonatomic, weak, readwrite) CPTXYAxis *yAxis;
- (NSArray*)graphPropertiesToObserve;
- (NSArray*)axisPropertiesToObserve;
- (void)commonInit;
- (void)adjustTitlePadding;
@end

#pragma mark -

@implementation DMXYGraph

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

- (NSArray*)graphPropertiesToObserve
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
	
	for (NSString *property in [self graphPropertiesToObserve])
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	
	// NOTE: don't observe axis properties until graph properties have been set in initializeGraph
}

- (void)dealloc
{
	for (NSString *property in [self graphPropertiesToObserve])
		[self removeObserver:self forKeyPath:property];
	
	for (CPTAxis *axis in @[self.xAxis, self.yAxis])
		for (NSString *property in [self axisPropertiesToObserve])
			[axis removeObserver:self forKeyPath:property];
}

- (void)initializeGraphWithXData:(NSArray*)xData yData:(NSArray*)yData // call after setting delegate, data source
{
	// set up data
	// -----------
	// Both data sets must be initially, mutually defined.
	// This avoids KVO from triggering "updateDataX" and "updateDataY" without one set being defined.
	_xData = xData;
	_yData = yData;

	
	// set up plot space
	// -----------------
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
	if (self.delegate)
		plotSpace.delegate = self;
	
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
	
	// set text styles
	// ---------------
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
	
	// set padding
	// -----------
	// padding: font size + 20
	//CGFloat axisLabelSize = 12.0; // default value
	self.plotAreaFrame.paddingLeft = self.yAxis.labelTextStyle.fontSize + self.yAxis.labelTextStyle.fontSize + 20.0;
	self.plotAreaFrame.paddingBottom = self.xAxis.labelTextStyle.fontSize + self.xAxis.labelTextStyle.fontSize + 20.0;
	
	[self updateYTitlePadding];
	[self updateXTitlePadding];
		
	// Constraints
	self.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	self.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
	
	// set up KVO after graph properties have been set
	for (CPTAxis *axis in @[self.xAxis, self.yAxis]) {
		for (NSString *property in [self axisPropertiesToObserve]) {
			[axis addObserver:self
						 forKeyPath:property
							options:NSKeyValueObservingOptionNew
							context:nil];
		}
	}
	
	
}

#pragma mark -
#pragma mark Private Properties

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


#pragma mark -
#pragma mark Padding

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

- (void)updateAxisLabelSize
{
	self.plotAreaFrame.paddingLeft = self.yAxis.labelTextStyle.fontSize + self.yAxis.labelTextStyle.fontSize + 20.0;
	self.plotAreaFrame.paddingBottom = self.xAxis.labelTextStyle.fontSize + self.xAxis.labelTextStyle.fontSize + 20.0;
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
			CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.defaultPlotSpace;
			plotSpace.delegate = self.delegate;
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
