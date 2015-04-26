//
//  CorePlotInspectorFramework.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for CorePlotInspectorFramework.
FOUNDATION_EXPORT double CorePlotInspectorFrameworkVersionNumber;

//! Project version string for CorePlotInspectorFramework.
FOUNDATION_EXPORT const unsigned char CorePlotInspectorFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CorePlotInspectorFramework/PublicHeader.h>

#import <CorePlotInspectorFramework/CPIInspectorWindowController.h>
#import <CorePlotInspectorFramework/IntegerSpaceFormatter.h>
#import <CorePlotInspectorFramework/ContinuousBindingFixNumberFormatter.h>

// To enable this, under Build Settings -> Other C Flags, add: "-DDLOG_DEBUG=1" under "debug"
#ifdef DLOG_DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
