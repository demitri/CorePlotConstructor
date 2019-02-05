//
//  DMCorePlotUtilities.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/10/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>

@interface DMCorePlotUtilities : NSObject

+ (void)setupXYGraph:(CPTXYGraph*)xyGraph withDataSource:(id<CPTPlotDataSource>)dataSource andDelegate:(id<CPTPlotSpaceDelegate>)delegate;


/*
 This function takes an array of NSNumber values and returns
 the minimum and maximum values in a two element array.
 */
+ (NSArray*)minMax:(NSArray*)values;


+ (NSArray*)niceRangeForValues:(NSArray*)values ticks:(NSInteger)noTicks;

@end
