//
//  Proton.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/5/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Proton.h"
#import "Particle.h"

@implementation Proton
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.charge = 1.0f;
        self.color = [UIColor redColor];
    }
    return self;
}
@end
