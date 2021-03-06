//
//  CPIXYGraphController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/26/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

// This is a controller class for items that are specific to "CPTXYGraph"s.

#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import "CPIGraphController.h"

@interface CPIXYGraphController : CPIGraphController

// self.graph is expected to be of type CPTXYGraph

@property (nonatomic, weak) CPTXYAxis *xAxis;
@property (nonatomic, weak) CPTXYAxis *yAxis;

- (instancetype)initWithGraph:(CPTXYGraph*)graph;

@end
