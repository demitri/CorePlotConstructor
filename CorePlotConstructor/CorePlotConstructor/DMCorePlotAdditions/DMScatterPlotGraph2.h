//
//  DMScatterPlotGraph2.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

// This is a full graph that contains a single scatter plot (which could also be a line plot).

#import "DMXYGraph.h"

@interface DMScatterPlotGraph2 : DMXYGraph <CPTPlotSpaceDelegate>

@property (nonatomic, weak) id<CPTPlotDataSource> dataSource;
@property (nonatomic, strong) CPTScatterPlot *scatterPlot;
@property (nonatomic, strong) NSArray *xMajorTickLocations;
@property (nonatomic, strong) NSArray *yMajorTickLocations;

@end
