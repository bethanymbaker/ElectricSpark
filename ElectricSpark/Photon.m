//
//  Photon.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 12/9/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "Photon.h"

@implementation Photon
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch
{
    self = [super initWithLocationOfTouch:locationOfTouch];
    if (self) {
        self.charge = 0.0f;
        self.mass = 0.0f;
        self.color = [UIColor grayColor];
    }
    return self;
}
@end