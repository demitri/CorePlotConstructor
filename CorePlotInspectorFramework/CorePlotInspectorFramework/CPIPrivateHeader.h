//
//  CPIPrivateHeader.h
//  CorePlotInspectorFramework
//
//  Created by Demitri Muna on 4/25/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#ifndef CorePlotInspectorFramework_CPIPrivateHeader_h
#define CorePlotInspectorFramework_CPIPrivateHeader_h

// 'define'-ing a string is often recommended against, but in this case the downsides don't apply
#define FRAMEWORK_BUNDLE_ID @"com.demitri.CorePlotInspectorFramework"


// To enable this, under Build Settings -> Other C Flags, add: "-DDLOG_DEBUG=1" under "debug"
#ifdef DLOG_DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#endif
