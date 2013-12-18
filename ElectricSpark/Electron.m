//
//  Electron.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/23/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Electron.h"

@implementation Electron
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.blue = 1.0f;
        self.alpha = (float)drand48();
        self.radius = 1;
        self.charge = -1;
        self.color = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
    }
    return self;
}
@end
