//
//  Electron.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/23/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#import "Particle.h"

@interface Electron : Particle
@property float charge;
@property UIColor *color;
@end
