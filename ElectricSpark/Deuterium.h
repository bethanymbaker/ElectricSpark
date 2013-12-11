//
//  Deuterium.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/10/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Particle.h"
#import "Hydrogen.h"
#import "Neutron.h"

@interface Deuterium : Particle
@property Hydrogen *hydrogen;
@property Neutron *neutron;
@end
