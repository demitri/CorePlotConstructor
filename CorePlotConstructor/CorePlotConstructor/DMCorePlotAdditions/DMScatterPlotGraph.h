//
//  DMScatterPlotGraph.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/27/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlot/CorePlot.h>

// This is a graph containing a single scatter plot/data source.

@interface DMScatterPlotGraph : CPTXYGraph <CPTPlotSpaceDelegate>

@property (nonatomic, weak) id<CPTPlotDataSource> dataSource;
@property (nonatomic, strong) CPTScatterPlot *scatterPlot; // line plot
@property (nonatomic, weak) NSArray *xData;
@property (nonatomic, weak) NSArray *yData;
@property (nonatomic, strong) NSArray *xMajorTickLocations;
@property (nonatomic, strong) NSArray *yMajorTickLocations;
@property (nonatomic, weak, readonly) CPTXYAxis *xAxis;
@property (nonatomic, weak, readonly) CPTXYAxis *yAxis;
@property (nonatomic, assign) BOOL allowsUserInteraction;

- (void)initializeGraph; // call after setting delegate, data source, data
- (void)setXData:(NSArray*)xData yData:(NSArray*)yData;
- (void)updateYTitlePadding;
- (void)updateXTitlePadding;

@end
