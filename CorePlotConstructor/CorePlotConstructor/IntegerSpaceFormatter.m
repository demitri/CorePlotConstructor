//
//  IntegerSpaceFormatter.m
//  CorePlotConstructor
//
//  Created by Demitri Muna on 8/21/14.
//  Copyright (c) 2014 Demitri Muna. All rights reserved.
//

#import "IntegerSpaceFormatter.h"
#include <ctype.h>

@implementation IntegerSpaceFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
	if (anObject == nil)
		return @"";
	if ([anObject isKindOfClass:[NSString class]])
		return [anObject copy];
	else
		NSAssert(1, @"unhandled type: %@", [anObject class]);
	return @"unhandled";
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
	*anObject = [string copy];
	return YES;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error
{
	//DLog(@"partialStringPtr : %@ / range: %@", *partialStringPtr, NSStringFromRange(*proposedSelRangePtr));
	
	for (NSUInteger i=0; i < [*partialStringPtr length]; i++) {
		unichar c = [*partialStringPtr characterAtIndex:i];
		// only allow numbers or spaces
		if (!(isdigit(c) || c == ' '))
			return NO;
	}
	
	return YES;
}



@end
