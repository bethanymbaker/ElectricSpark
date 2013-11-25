//
//  Electron.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/23/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Electron : NSObject

@property (readonly) CGPoint locationOfTouch;
@property (readonly) NSNumber *mass;
@property (readonly) NSNumber *charge;
@property CGPoint currentLocation;
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch;
@end
