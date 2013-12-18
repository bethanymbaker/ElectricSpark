//
//  Neutron.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/9/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Neutron.h"

@implementation Neutron
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.radius = 11;
        self.green = 1.0f;
        self.alpha = (float)drand48();
        self.color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
        self.charge = 0;
    }
    return self;
}
@end
