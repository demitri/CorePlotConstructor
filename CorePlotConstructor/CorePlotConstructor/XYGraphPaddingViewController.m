//
//  XYGraphPaddingViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/17/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "XYGraphPaddingViewController.h"

@interface XYGraphPaddingViewController ()

@end

@implementation XYGraphPaddingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (CPTGraph*)graph
{
	return mc.graph;
}

- (void)awakeFromNib
{
#pragma mark set up observers

	for (NSString *property in @[@"graphPaddingTop", @"graphPaddingLeft", @"graphPaddingRight", @"graphPaddingBottom"]) {
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}
}

- (void)dealloc
{
	for (NSString *property in @[@"graphPaddingTop", @"graphPaddingLeft", @"graphPaddingRight", @"graphPaddingBottom"]) {
		[self removeObserver:self forKeyPath:property];
	}
}

#pragma mark -
#pragma mark NSTextViewDelegate methods

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
	if (command == @selector(moveUp:) || command == @selector(moveDown:)) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:textView.string];
		if (number == nil)
			return NO; // not a number
		
		float delta = command == @selector(moveUp:) ? +1 : -1;
		
		BOOL handled = NO;
		
		switch (control.tag) {
				
			case GRAPH_PADDING_TOP:
				self.graph.paddingTop += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_BOTTOM:
				self.graph.paddingBottom += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_LEFT:
				self.graph.paddingLeft += delta;
				handled = YES;
				break;
			case GRAPH_PADDING_RIGHT:
				self.graph.paddingRight += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_TOP:
				self.graph.plotAreaFrame.paddingTop += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_BOTTOM:
				self.graph.plotAreaFrame.paddingBottom += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_LEFT:
				self.graph.plotAreaFrame.paddingLeft += delta;
				handled = YES;
				break;
			case PLOT_AREA_FRAME_RIGHT:
				self.graph.plotAreaFrame.paddingRight += delta;
				handled = YES;
				break;
			default:
				break;
		}
		if (handled)
			return YES;
		
		return NO;
	}
	
	return NO;
}

@end
