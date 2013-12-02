//
//  Electron.h
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/23/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@interface Electron : NSObject

//@property (readonly) CGPoint locationOfTouch;
@property (readonly) float mass;
@property (readonly) float charge;
@property Vector2D *r;
@property Vector2D *forceVector;
@property Vector2D *velocity;
- (id)initWithLocationOfTouch:(CGPoint)locationOfTouch;
- (void)calculateForceFromElectron:(Electron *)other;
- (void)calculateDisplacementWithDeltaT:(float)deltaT;
@end
