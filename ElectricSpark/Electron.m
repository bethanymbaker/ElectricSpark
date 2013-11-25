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
    self = [super init];
    if (self) {
        _mass = @9.11E-31;      // kg
        _charge = @1.6E-19;     // C
        _locationOfTouch = locationOfTouch;
        _currentLocation = locationOfTouch;
        return self;
    } else {
        return nil;
    }
}
@end
