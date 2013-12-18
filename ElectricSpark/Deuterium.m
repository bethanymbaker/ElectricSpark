//
//  Deuterium.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/10/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Deuterium.h"

@implementation Deuterium
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.radius = 22;
        self.color = [UIColor greenColor];
        self.hydrogen = [[Hydrogen alloc]initWithLocationOfTouch:locationOfTouch];
        self.neutron = [[Neutron alloc]initWithLocationOfTouch:locationOfTouch];
    }
    return self;
}
@end
