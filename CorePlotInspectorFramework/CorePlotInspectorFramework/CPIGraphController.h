//
//  CPIGraphController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/26/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

// This class is an abstract superclass for specific graph-type controllers.

#import <Cocoa/Cocoa.h>
#import "CPIGraphPaddingViewController.h"

@interface CPIGraphController : NSObjectController

@property (nonatomic, weak) CPTXYGraph *graph;

@property (nonatomic, strong) IBOutlet CPIGraphPaddingViewController *graphPaddingController;

- (void)resetLabelingPolicy;

@end
