//
//  CorePlotTextStyleViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/23/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CorePlotTextStyleViewController.h"

#define kInitialFont @"Helvetica"

@interface CorePlotTextStyleViewController ()
@property (nonatomic, strong, readwrite) CPTTextStyle *currentTextStyle;
- (NSArray*)propertiesToObserve;
- (CPTTextStyle*)textStyleFromCurrentView;
@end

@implementation CorePlotTextStyleViewController

/* Designated initializer */
- (id)init
{
	NSString *nibName = @"CorePlotTextStyleView";
	self = [super initWithNibName:nibName bundle:nil];
	if (self) {
		self.textColor = [NSColor blackColor]; // can't be nil when nib loads
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)awakeFromNib
{
	// set up fonts menu
	[fontsPopupButton removeAllItems];
	[fontsPopupButton addItemsWithTitles:[[NSFontManager sharedFontManager] availableFontFamilies]];
	[fontsPopupButton selectItemWithTitle:kInitialFont];

	// set up text alignment popup button
	[textAlignmentPopupButton removeAllItems];
	[textAlignmentPopupButton addItemsWithTitles:@[@"Left", @"Center", @"Right", @"Justified", @"Natural"]];
	[textAlignmentPopupButton itemWithTitle:@"Left"].tag = CPTTextAlignmentLeft;
	[textAlignmentPopupButton itemWithTitle:@"Center"].tag = CPTTextAlignmentLeft;
	[textAlignmentPopupButton itemWithTitle:@"Right"].tag = CPTTextAlignmentLeft;
	[textAlignmentPopupButton itemWithTitle:@"Justified"].tag = CPTTextAlignmentLeft;
	[textAlignmentPopupButton itemWithTitle:@"Natural"].tag = CPTTextAlignmentLeft;
	
	// set up line break mode popup
	[lineBreakModePopupButton removeAllItems];
	[lineBreakModePopupButton addItemsWithTitles:@[@"Wrap Word", @"Wrap Character", @"Clipping",
												   @"Truncating Head", @"Truncating Tail", @"Truncating Middle"]];
	[lineBreakModePopupButton itemWithTitle:@"Word Wrap"].tag = NSLineBreakByWordWrapping;
	[lineBreakModePopupButton itemWithTitle:@"Wrap Character"].tag = NSLineBreakByCharWrapping ;
	[lineBreakModePopupButton itemWithTitle:@"Clipping"].tag = NSLineBreakByClipping;
	[lineBreakModePopupButton itemWithTitle:@"Truncating Head"].tag = NSLineBreakByTruncatingHead;
	[lineBreakModePopupButton itemWithTitle:@"Truncating Tail"].tag = NSLineBreakByTruncatingTail;
	[lineBreakModePopupButton itemWithTitle:@"Truncating Middle"].tag = NSLineBreakByTruncatingMiddle;
	

	for (NSString *property in self.propertiesToObserve)
		[self addObserver:self
			   forKeyPath:property
				  options:NSKeyValueObservingOptionNew
				  context:nil];
}

- (NSArray*)propertiesToObserve
{
	return @[@"fontSize", @"textColor"];
}

- (void)dealloc
{
	for (NSString *property in self.propertiesToObserve)
		[self removeObserver:self forKeyPath:property];
}

- (void)updateWithTextStyle:(CPTTextStyle *)newTextStyle
{
	if (newTextStyle == nil) {
		CPTMutableTextStyle *defaultTextStyle = [CPTMutableTextStyle textStyle];
		// default values
		newTextStyle = defaultTextStyle;
	}

	// update view with the properties of the newTextStyle
	[fontsPopupButton selectItemWithTitle:newTextStyle.fontName];
	[textAlignmentPopupButton selectItemWithTag:newTextStyle.textAlignment];
	[lineBreakModePopupButton selectItemWithTag:newTextStyle.lineBreakMode];
	self.textColor = newTextStyle.color.nsColor;
	self.fontSize = newTextStyle.fontSize;
}

- (void)popupMenuChanged:(id)sender
{
	self.currentTextStyle = [self textStyleFromCurrentView];
}

// getter
- (CPTTextStyle*)currentTextStyle
{
	return [self textStyleFromCurrentView];
}

- (CPTTextStyle*)textStyleFromCurrentView
{
	// return a new CPTTextStyle based on the properties of the view.
	CPTMutableTextStyle *newTextStyle = [[CPTMutableTextStyle alloc] init];
	
	newTextStyle.color = [[CPTColor alloc] initWithCGColor:self.textColor.CGColor];
	newTextStyle.fontSize = self.fontSize;
	newTextStyle.fontName = [fontsPopupButton titleOfSelectedItem];
	newTextStyle.lineBreakMode = lineBreakModePopupButton.selectedTag;
	newTextStyle.textAlignment = textAlignmentPopupButton.selectedTag;

	return newTextStyle;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//DLog(@"%@ changed", keyPath);
	if ([self.propertiesToObserve containsObject:keyPath])
		self.currentTextStyle = [self textStyleFromCurrentView];
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
				
		switch (control.tag) {
				
			case 1: // font size
				// min value = 5
				if ((self.fontSize += delta) < 5)
					self.fontSize = 5;
				else
					self.fontSize += delta;
				handled = YES;
				break;
				
		}
		return handled;
	}
	
	return handled;
}

@end
