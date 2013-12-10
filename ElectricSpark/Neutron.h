//
//  Neutron.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/9/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Particle.h"
#import "Electron.h"
#import "Proton.h"

@interface Neutron : Particle
@property Proton *proton;
@property Electron *electron;
@end
