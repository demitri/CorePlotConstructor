//
//  CPTMutableLineStyle+Copies.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/28/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlot/CorePlot.h>

@interface CPTMutableLineStyle (Copies)

+ (instancetype)lineStyleWithStyle:(CPTLineStyle*)lineStyle;

@end
