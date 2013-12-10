//
//  Particle.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/2/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Particle.h"

@implementation Particle

- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super init];
    if (self) {
        _charge = 0.0f;
        _color = [UIColor yellowColor];
        _mass = 1.0f;
        _displacement = [[Vector2D alloc]initWithX:locationOfTouch.x Y:locationOfTouch.y];
        _forceVector = [[NSMutableArray alloc]init];
        _lengthForceVector = 10;
        for (int i = 0; i<_lengthForceVector; i++) {
            [_forceVector addObject:[[Vector2D alloc]init]];
        }
        return self;
    } else {
        return nil;
    }
}

@end
