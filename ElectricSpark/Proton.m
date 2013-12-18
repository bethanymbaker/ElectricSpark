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
        self.radius = 10;
        self.charge = 1.0f;
        self.color = [UIColor redColor];
    }
    return self;
}
@end
