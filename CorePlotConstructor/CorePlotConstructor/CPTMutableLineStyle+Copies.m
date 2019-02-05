//
//  CPTMutableLineStyle+Copies.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/28/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPTMutableLineStyle+Copies.h"

@implementation CPTMutableLineStyle (Copies)

+ (instancetype)lineStyleWithStyle:(CPTLineStyle*)lineStyle
{
	CPTMutableLineStyle *newStyle = [[CPTMutableLineStyle alloc] init];
	newStyle.dashPattern = [NSArray arrayWithArray:lineStyle.dashPattern];
	newStyle.lineCap = lineStyle.lineCap;
	newStyle.lineColor = lineStyle.lineColor;
	newStyle.lineFill = lineStyle.lineFill;
	newStyle.lineGradient = lineStyle.lineGradient;
	newStyle.lineJoin = lineStyle.lineJoin;
	newStyle.lineWidth = lineStyle.lineWidth;
	newStyle.miterLimit = lineStyle.miterLimit;
	newStyle.patternPhase = lineStyle.patternPhase;
	
	return newStyle;
}

@end
