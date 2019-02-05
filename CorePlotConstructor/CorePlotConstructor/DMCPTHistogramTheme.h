//
//  DMCPTHistogramTheme.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/16/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlot/CorePlot.h>
#import <Foundation/Foundation.h>

@interface DMCPTHistogramTheme : CPTTheme

@property (nonatomic, weak) NSArray *xData;
@property (nonatomic, weak) NSArray *yData;
@property (nonatomic, strong) NSArray *xMajorTickLocations;
@property (nonatomic, strong) NSArray *yMajorTickLocations;

@end
