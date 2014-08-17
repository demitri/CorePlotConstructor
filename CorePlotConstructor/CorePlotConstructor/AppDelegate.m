//
//  AppDelegate.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 9/29/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	[NSNumberFormatter setDefaultFormatterBehavior:NSNumberFormatterBehavior10_4];
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
}

@end
