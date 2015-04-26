//
//  CPIXYGraphController.m
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/26/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPIXYGraphController.h"
#import "XYGraphAxisLabelsViewController.h"

@implementation CPIXYGraphController

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self addObserver:self
			   forKeyPath:@"graph"
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}
	return self;
}

- (instancetype)initWithGraph:(CPTXYGraph*)graph
{
	self = [super init];
	self.graph = graph;
	return self;
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"graph"];
}

#pragma mark -

- (CPTXYAxis*)xAxis
{
	if (_xAxis == nil) {
		_xAxis = ((CPTXYAxisSet *)self.graph.axisSet).xAxis;
	}
	return _xAxis;
}

- (CPTXYAxis*)yAxis
{
	if (_yAxis == nil) {
		_yAxis = ((CPTXYAxisSet *)self.graph.axisSet).yAxis;
	}
	return _yAxis;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self) {
		if ([keyPath isEqualToString:@"graph"]) {
			self.xAxis = nil;
			self.yAxis = nil;
		}
	}
}

- (void)resetLabelingPolicy:(NSArray*)axesPolices
{

	self.xAxis.labelingPolicy = [axesPolices[0] intValue];
	self.yAxis.labelingPolicy = [axesPolices[1] intValue];

//	self.xAxis.labelingPolicy = self.inspector.axisLabelsController.xAxisLabelingPolicyPopup.selectedItem.tag;
//	self.yAxis.labelingPolicy = self.inspector.axisLabelsController.yAxisLabelingPolicyPopup.selectedItem.tag;
	
//	self.xAxis.labelingPolicy = self.axisLabelsController.xAxisLabelingPolicyPopup.selectedItem.tag;
//	self.yAxis.labelingPolicy = self.axisLabelsController.yAxisLabelingPolicyPopup.selectedItem.tag;

}

@end
