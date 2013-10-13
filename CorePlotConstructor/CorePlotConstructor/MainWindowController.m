//
//  MainWindowController.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 9/29/13.
//  Copyright (c) 2013 Demitri Muna. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)inspectorPopupAction:(id)sender
{
	NSPopUpButton *popupButton = (NSPopUpButton*)sender;
	[inspectorTabView selectTabViewItemAtIndex:popupButton.selectedItem.tag];
	
	/*
	switch (popupButton.selectedItem.tag) {
		case PLOT_INSPECTOR_PANEL:
			break;
		case AXES_INSPECTOR_PANEL:
			break;
		case PADDING_INSPECTOR_PANEL;
			break;
	}
	 */
}

@end
