//
//  DMHistogram.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 7/5/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHistogram : NSObject

@property (nonatomic, strong) NSArray *counts; // frequency per bin
@property (nonatomic, assign) NSUInteger numberOfBins;


@end
