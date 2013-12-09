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
        _force = [[Vector2D alloc]init];
        _velocity = [[Vector2D alloc]init];
        _electrostaticForce = [[Vector2D alloc]init];
        _repulsiveForce = [[Vector2D alloc]init];
        return self;
    } else {
        return nil;
    }
}

@end
