//
//  AppDelegate.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 9/29/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "AppDelegate.h"
//#import "CPCDashPatternValueTransformer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[NSNumberFormatter setDefaultFormatterBehavior:NSNumberFormatterBehavior10_4];
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
/*
	// register value transformers
	CPCDashPatternValueTransformer *dashPatternValueTransformer = [[CPCDashPatternValueTransformer alloc] init];
	[CPCDashPatternValueTransformer setValueTransformer:dashPatternValueTransformer
												forName:@"CPCDashPatternValueTransformer"];
	
	// set up number formatters
	NSNumberFormatter *decimalNF = [[NSNumberFormatter alloc] init];
	decimalNF.numberStyle = NSNumberFormatterDecimalStyle;
	decimalNF.usesSignificantDigits = YES;
	decimalNF.maximumSignificantDigits = 1;
	_decimalNumberFormatter = decimalNF;
*/
 }

@end
