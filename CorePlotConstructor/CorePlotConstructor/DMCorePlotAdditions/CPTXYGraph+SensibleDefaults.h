//
//  CPTXYPlotSpace+SensibleDefaults.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/10/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

@interface CPTXYPlotSpace (SensibleDefaults)

- (void)setupDefaultIntervalsWithXRange:(NSArray*)xRange andYRange:(NSArray*)yRange;
- (CGFloat)_niceNumber:(CGFloat)x round:(BOOL)round;

@end
