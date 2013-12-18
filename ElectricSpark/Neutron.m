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
        self.color = [UIColor yellowColor];
        self.charge = 0.0f;
        self.electron = [[Electron alloc]initWithLocationOfTouch:locationOfTouch];
        self.proton = [[Proton alloc]initWithLocationOfTouch:locationOfTouch];
    }
    return self;
}
@end
