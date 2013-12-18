//
//  Proton.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/5/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Proton.h"

@implementation Proton
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.red = 1.0f;
        self.alpha = (float)drand48();
        self.radius = 10;
        self.charge = 1;
        self.color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
    }
    return self;
}
@end
