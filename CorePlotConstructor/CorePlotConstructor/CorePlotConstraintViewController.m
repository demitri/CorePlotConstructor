//
//  CorePlotConstraintViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/24/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CorePlotConstraintViewController.h"

@interface CorePlotConstraintViewController ()
@property (nonatomic, strong, readwrite) CPTConstraints* currentConstraints;
- (CPTConstraints*)constraintsFromCurrentView;
@end

@implementation CorePlotConstraintViewController

/* Designated initializer */
- (instancetype)init
{
	NSString *nibName = @"CorePlotConstraintViewController";
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self init];
}

- (void)awakeFromNib
{
	[constraintPopupButton removeAllItems];
	[constraintPopupButton addItemsWithTitles:@[@"Lower Bound", @"Upper Bound", @"Relative"]];
	[constraintPopupButton itemWithTitle:@"Lower Bound"].tag = LOWER_OFFSET;
	[constraintPopupButton itemWithTitle:@"Upper Bound"].tag = UPPER_OFFSET;
	[constraintPopupButton itemWithTitle:@"Relative"].tag = RELATIVE_OFFSET;
	
	[self addObserver:self
		   forKeyPath:@"offset"
			  options:NSKeyValueObservingOptionNew
			  context:nil];
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"offset"];
}

- (void)updateWithConstraints:(CPTConstraints*)newConstraints
{
	if (newConstraints == nil)
		newConstraints = [CPTConstraints constraintWithLowerOffset:0.0];

	// self.offsetPosition = This seems to be a private value - can this be done?
}

- (void)popupMenuChanged:(id)sender
{
	self.currentConstraints = [self constraintsFromCurrentView];
}

- (CPTConstraints*)currentConstraints
{
	return [self constraintsFromCurrentView];
}

- (CPTConstraints*)constraintsFromCurrentView
{
	CPTConstraints *newConstriants;
	switch (constraintPopupButton.tag) {
		case LOWER_OFFSET:
			newConstriants = [[CPTConstraints alloc] initWithLowerOffset:self.offset];
			break;
		case UPPER_OFFSET:
			newConstriants = [[CPTConstraints alloc] initWithUpperOffset:self.offset];
			break;
		case RELATIVE_OFFSET:
			newConstriants = [[CPTConstraints alloc] initWithRelativeOffset:self.offset];
			break;
	}
	return newConstriants;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@ changed", keyPath);
	if ([keyPath isEqualToString:@"offset"])
		self.currentConstraints = [self constraintsFromCurrentView];
}

#pragma mark -
#pragma mark NSTextViewDelegate methods

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	BOOL handled = NO;

	//DLog(@"command: %@", NSStringFromSelector(command));
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number
		
		float delta = command == @selector(moveUp:) ? +1.0 : -1.0;
		
		self.offset += delta;
		handled = YES;
	}
	return handled;
}
@end
