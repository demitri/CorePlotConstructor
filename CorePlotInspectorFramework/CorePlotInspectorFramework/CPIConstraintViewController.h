//
//  CPIConstraintViewController.h
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/24/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>

/* This is a controller for an NSPopupView.
 This class is an editor for CPTConstraint objects. */

enum CONTRAINT_VALUES {
	LOWER_OFFSET = 1,
	UPPER_OFFSET,
	RELATIVE_OFFSET
};

@interface CPIConstraintViewController : NSViewController
{
	IBOutlet NSPopUpButton *constraintPopupButton;
}

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong, readonly) CPTConstraints* currentConstraints;


- (IBAction)popupMenuChanged:(id)sender;
- (void)updateWithConstraints:(CPTConstraints*)newConstraints;

@end
