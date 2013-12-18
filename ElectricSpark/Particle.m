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
    self.displacement = [[Vector2D alloc]initWithX:locationOfTouch.x Y:locationOfTouch.y];
    self.force = [[Vector2D alloc]init];
    return self;
}

- (id)initWithParticle:(Particle *)p1 andParticle:(Particle *)p2
{
    self = [super init];
    self.alpha = 1.0f;
    self.charge = [p1 charge]+[p2 charge];
    self.radius = [p1 radius] + [p2 radius];
    self.red = ([p1 alpha]*[p1 red]*[p1 radius]+[p2 alpha]*[p2 red]*[p2 radius])/self.radius;
    self.blue = ([p1 alpha]*[p1 blue]*[p1 radius]+[p2 alpha]*[p2 blue]*[p2 radius])/self.radius;
    self.green = ([p1 alpha]*[p1 green]*[p1 radius]+[p2 alpha]*[p2 green]*[p2 radius])/self.radius;
    self.displacement = [[Vector2D alloc]initWithX:[[p1 displacement]x] Y:[[p1 displacement]y]];
    self.force = [[Vector2D alloc]init];
    self.color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
    return self;
}

@end
