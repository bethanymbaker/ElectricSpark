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
        self.mass = 1000.0f;
        self.charge = 0.0f;
        self.color = [UIColor whiteColor];
    }
    return self;
}
@end
