//
//  VectorND.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/24/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "VectorND.h"

@implementation VectorND
- (id)init
{
    return [super init];
    /*
	if([self class] == [VectorND class]) {
		NSAssert(false, @"You cannot init this class directly. Instead, use a subclass e.g. Vector2D.");
		return nil;
	} else {
		return [super init];
    }
     */
}
+ (CGFloat)dotProduct:(VectorND *)aVector
{
    if ([self class] == [VectorND class]) {
        NSAssert(false, @"You can only take the dot product of a VectorND subclass e.g. Vector 2D.");
        return 0.0;
    } else if ([self class] == [aVector class]) {
        CGFloat sum = 0.0;
        for (int i = 0; i<[self count]; i++) {
            sum = sum + [self objectAtIndex:i] + [aVector objectAtIndex:i];
        }
        return sum;
    } else {
        
    }
}
@end
