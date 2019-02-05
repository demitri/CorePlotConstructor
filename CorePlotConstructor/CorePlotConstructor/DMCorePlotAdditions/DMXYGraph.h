//
//  DMXYGraph.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/3/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlot/CorePlot.h>

@interface DMXYGraph : CPTXYGraph <CPTPlotSpaceDelegate>

@property (nonatomic, weak, readonly) CPTXYAxis *xAxis;
@property (nonatomic, weak, readonly) CPTXYAxis *yAxis;
@property (nonatomic, weak) NSArray *xData;
@property (nonatomic, weak) NSArray *yData;
@property (nonatomic, assign) BOOL allowsUserInteraction;

- (void)initializeGraphWithXData:(NSArray*)xData yData:(NSArray*)yData; // call after setting delegate, data source
- (void)updateXTitlePadding;
- (void)updateYTitlePadding;

@end
