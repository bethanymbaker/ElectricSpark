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

@property float charge;
@property int radius;
@property Vector2D *displacement;
@property UIColor *color;
@property Vector2D *force;
@property float alpha;
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch;

@end
