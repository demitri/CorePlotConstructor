//
//  ContinuousBindingFixNumberFormatter.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/23/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "ContinuousBindingFixNumberFormatter.h"

@implementation ContinuousBindingFixNumberFormatter

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error
{
	float floatValue;
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	if ([scanner scanFloat:&floatValue] && [scanner isAtEnd]) {
		if (object)
			*object = [NSNumber numberWithFloat:floatValue]; //[NSString stringWithString:string];
		return YES;
	} else {
		if (error)
			*error = @"Not a valid numerical value.";
		return NO;
	}
}

@end
