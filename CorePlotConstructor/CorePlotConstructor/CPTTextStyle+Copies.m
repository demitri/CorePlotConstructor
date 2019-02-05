//
//  CPTTextStyle+Copies.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 5/28/15.
//  Copyright (c) 2015 Demitri Muna. All rights reserved.
//

#import "CPTTextStyle+Copies.h"

@implementation CPTTextStyle (Copies)

+ (instancetype)textStyleWithStyle:(CPTTextStyle*)textStyle
{
	CPTMutableTextStyle *newTextStyle = [[CPTMutableTextStyle alloc] init];
	newTextStyle.color = [CPTColor colorWithCGColor:newTextStyle.color.cgColor];
	newTextStyle.fontName = textStyle.fontName;
	newTextStyle.fontSize = textStyle.fontSize;
	newTextStyle.lineBreakMode = textStyle.lineBreakMode;
	newTextStyle.textAlignment = textStyle.textAlignment;
	
	return newTextStyle;
}

@end
