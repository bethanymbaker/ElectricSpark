//
//  Particle.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/2/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@interface Particle : NSObject

@property float mass;
@property float charge;
@property Vector2D *displacement;
@property Vector2D *force;
@property Vector2D *velocity;
@property UIColor *color;
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch;

@end
