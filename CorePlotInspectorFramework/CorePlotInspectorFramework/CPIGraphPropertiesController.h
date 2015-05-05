//
//  CPIGraphPropertiesController.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 5/5/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <CorePlotInspectorFramework/CorePlotInspectorFramework.h>
#import "CPITextStyleViewController.h"
#import "CPILineStyleViewController.h"

@interface CPIGraphPropertiesController : CPIPlotInspectorViewController <NSTextFieldDelegate, NSPopoverDelegate>
{
	IBOutlet NSPopUpButton *themePopup;
	IBOutlet NSPopUpButton *graphTitleFrameAnchorPopup;
}
// Graph title properties
@property (strong, nonatomic) NSColor *titleColor;
@property (assign) CGFloat graphTitleDisplacementX;
@property (assign) CGFloat graphTitleDisplacementY;

// properties for editing CPTTextStyle objects
@property (strong, nonatomic) NSPopover *textStylePopover;
@property (strong, nonatomic) CPITextStyleViewController *textStyleViewController;

// properties for editing CPTLineStyle objects
@property (strong, nonatomic) NSPopover *lineStylePopover;
@property (strong, nonatomic) CPILineStyleViewController *lineStyleViewController;
@property (nonatomic, assign) NSInteger lineStyleBeingEdited;

- (IBAction)editTextStyle:(id)sender;
- (IBAction)changeTheme:(id)sender;
- (IBAction)changeTitleAnchorStyle:(id)sender;

@end
