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
        return self;
    } else {
        return nil;
    }
}
- (void)calculateForceFromParticle:(Particle *)other
{
    if ([self isEqual:other]) {
        
    } else {
        Vector2D *deltaR = [other.displacement sub:self.displacement];
        float length = [deltaR length];
        float magnitude = - ( self.charge * other.charge ) / (length*length*length);
        Vector2D *force = [[Vector2D alloc]initWithX:magnitude*deltaR.x Y:magnitude*deltaR.y];
        _force = [_force add:force];
    }
}
- (void)calculateDisplacementWithDeltaT:(float)deltaT
{
    Vector2D *initialDisplacement = self.displacement;
    Vector2D *initialVelocity = self.velocity;
    Vector2D *initialAcceleration = [self.force div:self.mass];
    Vector2D *finalDisplacement = [[initialDisplacement add:[initialVelocity mult:deltaT]] add:[initialAcceleration mult:0.5f*deltaT*deltaT]];
    Vector2D *finalVelocity = [initialVelocity add:[initialAcceleration mult:deltaT]];
    self.displacement = finalDisplacement;
    self.velocity = finalVelocity;
}
@end
