//
//  Hydrogen.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/10/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Hydrogen.h"

@implementation Hydrogen
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.radius = 11;
        self.color = [UIColor purpleColor];
        self.electron = [[Electron alloc]initWithLocationOfTouch:locationOfTouch];
        self.proton = [[Proton alloc]initWithLocationOfTouch:locationOfTouch];
    }
    return self;
}
@end
