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
        self.mass = 1001.0f;
        self.charge = 0.0f;
        self.color = [UIColor whiteColor];
        self.electron = [[Electron alloc]initWithLocationOfTouch:locationOfTouch];
        self.electron.color = self.color;
        self.proton = [[Proton alloc]initWithLocationOfTouch:locationOfTouch];
        self.proton.color = self.color;
    }
    return self;
}
@end
