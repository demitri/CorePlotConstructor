//
//  CPITextStyleViewController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/23/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import <CorePlot/CorePlot.h>
#import "CPITextStyleViewController.h"
#import "CPIPrivateHeader.h"

#define kInitialFont @"Helvetica"
#define MIN_FONT_SIZE 4.0f

@interface CPITextStyleViewController ()
@property (nonatomic, strong, readwrite) CPTTextStyle *currentTextStyle;
- (void)commonInit;
- (NSArray*)propertiesToObserve;
- (CPTTextStyle*)textStyleFromCurrentView;
@end

@implementation CPITextStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//	NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"" withExtension:@"bundle"]];
	// Ref: http://stackoverflow.com/questions/12557936/loading-a-nib-thats-included-in-a-framework
	NSString *frameworkBundleID = FRAMEWORK_BUNDLE_ID;
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
	self = [super initWithNibName:@"CPITextStyleView" bundle:frameworkBundle];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)commonInit
{
	self.textColor = [NSColor blackColor]; // can't be nil when nib loads

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
	[textAlignmentPopupButton itemWithTitle:@"Center"].tag = CPTTextAlignmentCenter;
	[textAlignmentPopupButton itemWithTitle:@"Right"].tag = CPTTextAlignmentRight;
	[textAlignmentPopupButton itemWithTitle:@"Justified"].tag = CPTTextAlignmentJustified;
	[textAlignmentPopupButton itemWithTitle:@"Natural"].tag = CPTTextAlignmentNatural;
	
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
	// if any of the properties change, create a new CPTTextStyle object based on the view
	if ([self.propertiesToObserve containsObject:keyPath]) {
		self.currentTextStyle = [self textStyleFromCurrentView];
		//DLog(@"%@", keyPath);
	}
}

#pragma mark -
#pragma mark Property validation methods

- (BOOL)validateFontSize:(id *)ioValue error:(NSError * __autoreleasing *)returnedError
{
	// if the field becomes nil (value deleted), program will immediately crash
	
	if (*ioValue == nil || ![*ioValue isKindOfClass:NSNumber.class])
		*ioValue = [NSNumber numberWithFloat:MIN_FONT_SIZE];
	else if ([*ioValue isKindOfClass:NSNumber.class]) {
		if ([*ioValue floatValue] <= MIN_FONT_SIZE) // minimum allowable font size
			*ioValue = [NSNumber numberWithFloat:MIN_FONT_SIZE];
	}
	return YES;
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
				if ((self.fontSize += delta) <= MIN_FONT_SIZE)
					self.fontSize = MIN_FONT_SIZE;
				else
					self.fontSize += delta;
				handled = YES;
				break;
			default:
				NSAssert(FALSE, @"unhandled tag");
				break;
				
		}
		return handled;
	}
	
	return handled;
}

@end
