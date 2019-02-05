//
//  DMHistogramGraph.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "DMXYGraph.h"

@interface DMHistogramGraph : DMXYGraph <CPTPlotSpaceDelegate>

@property (nonatomic, weak) id<CPTPlotDataSource> dataSource;
@property (nonatomic, strong) CPTBarPlot *barPlot;

@end
