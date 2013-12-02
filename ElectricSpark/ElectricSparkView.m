//
//  ElectricSparkView.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/24/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "ElectricSparkView.h"
#import "Electron.h"
#import "Vector2D.h"

@interface ElectricSparkView ()
@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSMutableArray *listOfElectrons;
@property (nonatomic) float deltaT;
- (void)drawElectrons;
@end

@implementation ElectricSparkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor magentaColor];
        _listOfElectrons = [[NSMutableArray alloc]init];
        _deltaT = 0.2f;
        [self animate];
    }
    return self;
}
- (void)animate
{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _locationOfTouch = [touch locationInView:self];
    Electron *electron = [[Electron alloc]initWithLocationOfTouch:_locationOfTouch];
    if (electron) {
        [_listOfElectrons addObject:electron];
        [self setNeedsDisplay];
        [self calculateElectronForces];
        [self calculateDisplacements];
        [self setNeedsDisplay];
    }
}
- (void)calculateDisplacements
{
    for (Electron *electron in self.listOfElectrons) {
        Vector2D *initialDisplacement = electron.r;
        Vector2D *initialVelocity = electron.velocity;
        Vector2D *initialAcceleration = [electron.forceVector div:electron.mass];
        Vector2D *finalDisplacement = [[initialDisplacement add:[initialVelocity mult:_deltaT]] add:[initialAcceleration mult:0.5f*_deltaT*_deltaT]];
        Vector2D *finalVelocity = [initialVelocity add:[initialAcceleration mult:_deltaT]];
        electron.r = finalDisplacement;
        electron.velocity = finalVelocity;
    }
}
- (void)calculateElectronForces
{
    for (Electron *e1 in _listOfElectrons) {
        for (Electron *e2 in _listOfElectrons) {
            if (![e1 isEqual:e2]) {
                Vector2D *deltaR = [Vector2D sub:e2.r with:e1.r];
                float length = [deltaR length];
                float magnitude = - ( e1.charge * e2.charge ) / (length*length*length);
                Vector2D *force = [Vector2D mult:deltaR with:magnitude];
                [e1.forceVector add:force];
            }
        }
    }
}
- (void)drawRect:(CGRect)rect
{
    [self drawElectrons];
}
- (void)drawElectrons
{
    UIColor *color = [UIColor yellowColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    for (Electron *electron in _listOfElectrons) {
        CGContextStrokeEllipseInRect(context, CGRectMake(electron.r.x, electron.r.y, 10.0, 10.0));
        CGContextFillEllipseInRect(context, CGRectMake(electron.r.x, electron.r.y, 10.0, 10.0));
    }
}
@end
