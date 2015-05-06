//
//  CPIXYGraphDataViewController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 5/6/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlotInspectorFramework/CorePlotInspectorFramework.h>
#import "CPIPlotInspectorViewController.h"
#import "CPILineStyleViewController.h"

@interface CPIXYGraphDataViewController : CPIPlotInspectorViewController <NSPopoverDelegate>
@property (nonatomic, strong) CPILineStyleViewController *lineStyleController;
@end
