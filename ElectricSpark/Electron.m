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
        self.mass = 1.0f;
        self.charge = -1.0f;
        self.color = [UIColor yellowColor];
    }
    return self;
}
@end
