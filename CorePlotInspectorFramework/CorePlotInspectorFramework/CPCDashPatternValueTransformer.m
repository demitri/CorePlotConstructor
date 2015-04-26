//
//  CPCDashPatternValueTransformer.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/21/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "CPCDashPatternValueTransformer.h"
#import "CPIPrivateHeader.h"

@implementation CPCDashPatternValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

// model -> display : return a string from an array of numbers
- (id)transformedValue:(id)value
{
	DLog(@"");
	// empty string translates to nil
	if (value == nil)
		return @"";
	
	NSMutableArray *arrayOfStrings = [NSMutableArray array];
	for (NSNumber *n in value) {
		[arrayOfStrings addObject:n.stringValue];
	}
	return [arrayOfStrings componentsJoinedByString:@" "];
}

// display -> model : return an array of numbers from a string
- (id)reverseTransformedValue:(id)value
{
	DLog(@"Displayed value (%@): %@", [value class], value);
	if ([value isKindOfClass:[NSString class]]) {
		if (value == nil || [(NSString*)value length] == 0)
			return nil;
	} else if ([value isKindOfClass:[NSNumber class]]) {
		return [NSArray arrayWithObject:[value copy]];
	} else
		NSAssert(1, @"unexpected value class: %@", [value class]);
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

	NSMutableArray *pattern = [NSMutableArray array];
	for (NSString *s in [value componentsSeparatedByString:@" "]) {
		[pattern addObject:[formatter numberFromString:s]];
	}

	return pattern;
}

@end
