//
//  CPCDashPatternValueTransformer.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/21/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class handles the display of dash pattern values (e.g. the line style editor).

// model: NSArray of NSDecimalNumber values
// display: NSString representing decimal values separated by single spaces

// Ref:
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ValueTransformers/ValueTransformers.html
// http://www.cocoalab.com/?q=node/26


@interface CPCDashPatternValueTransformer : NSValueTransformer

@end
