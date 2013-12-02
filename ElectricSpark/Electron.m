//
//  Electron.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/23/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Electron.h"
#import "Vector2D.h"

@implementation Electron
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super init];
    if (self) {
        _charge = -1.0f;
        _mass = 1.0f;
        _r = [[Vector2D alloc]initWithX:locationOfTouch.x Y:locationOfTouch.y];
        _forceVector = [[Vector2D alloc]init];
        _velocity = [[Vector2D alloc]init];
        return self;
    } else {
        return nil;
    }
}
- (void)calculateForceFromElectron:(Electron *)other
{
    if ([self isEqual:other]) {
    
    } else {
        Vector2D *deltaR = [other.r sub:self.r];
        float length = [deltaR length];
        float magnitude = - ( self.charge * other.charge ) / (length*length*length);
        Vector2D *force = [[Vector2D alloc]initWithX:magnitude*deltaR.x Y:magnitude*deltaR.y];
        _forceVector = [_forceVector add:force];
    }
}
- (void)calculateDisplacementWithDeltaT:(float)deltaT
{
    Vector2D *initialDisplacement = self.r;
    Vector2D *initialVelocity = self.velocity;
    Vector2D *initialAcceleration = [self.forceVector div:self.mass];
    Vector2D *finalDisplacement = [[initialDisplacement add:[initialVelocity mult:deltaT]] add:[initialAcceleration mult:0.5f*deltaT*deltaT]];
    Vector2D *finalVelocity = [initialVelocity add:[initialAcceleration mult:deltaT]];
    self.r = finalDisplacement;
    self.velocity = finalVelocity;
}
@end
