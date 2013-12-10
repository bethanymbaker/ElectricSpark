//
//  ElectricSparkView.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/24/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "ElectricSparkView.h"
#import "Electron.h"
#import "Proton.h"
#import "Vector2D.h"
#import "Particle.h"
#import "Neutron.h"

@interface ElectricSparkView ()
@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSMutableArray *listOfParticles;
@property (nonatomic) float deltaT;
@property (nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@end

@implementation ElectricSparkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor magentaColor];
        _listOfParticles = [[NSMutableArray alloc]init];
        _deltaT = 0.5f;
        _singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addElectron:)];
        _singleTapRecognizer.delaysTouchesEnded = YES;
        _singleTapRecognizer.numberOfTapsRequired = 1;
        
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProton:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
        
        [_singleTapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
        
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addNeutron:)];
        [_singleTapRecognizer requireGestureRecognizerToFail:_longPressRecognizer];
        
        [self addGestureRecognizer:_singleTapRecognizer];
        [self addGestureRecognizer:_doubleTapRecognizer];
        [self addGestureRecognizer:_longPressRecognizer];
        [self setMultipleTouchEnabled:YES];
        [self animate];
    }
    return self;
}
- (void)addNeutron:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view self]];
    Neutron *neutron = [[Neutron alloc]initWithLocationOfTouch:location];
    if (neutron) {
        [_listOfParticles addObject:neutron];
        [self setNeedsDisplay];
    }
}
- (void)addElectron:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:[recognizer.view self]];
        Electron *electron = [[Electron alloc]initWithLocationOfTouch:location];
        if (electron) {
            [_listOfParticles addObject:electron];
            [self setNeedsDisplay];
        }
    }
    
}
- (void)addProton:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:[recognizer.view self]];
        Proton *proton = [[Proton alloc]initWithLocationOfTouch:location];
        if (proton) {
            [_listOfParticles addObject:proton];
            [self setNeedsDisplay];
        }
    }
    
}
- (void)animate
{
    [NSTimer scheduledTimerWithTimeInterval:1.0/20.0*_deltaT target:self selector:@selector(animate) userInfo:NULL repeats:NO];
    [self calculateForces];
    [self calculateDisplacements];
    [self setNeedsDisplay];
}
- (void)calculateDisplacements
{
    for (id particle in _listOfParticles) {
        Vector2D *displacement = [particle displacement];
        for (int i = 0; i<[particle lengthForceVector]; i++) {
            if ([[particle class]isSubclassOfClass:[Neutron class]]) {
                [displacement add:[[[particle proton]forceVector] objectAtIndex:i]];
                [displacement add:[[[particle electron]forceVector] objectAtIndex:i]];
            } else {
                [displacement add:[[particle forceVector] objectAtIndex:i]];
            }
        }
        [particle setDisplacement:displacement];
    }
}
- (void)calculateForces
{
    for (id p1 in _listOfParticles) {
        for (id p2 in _listOfParticles) {
            if ([p1 isEqual:p2]) {
                
            } else {
                if ([[p1 class]isSubclassOfClass:[Neutron class]]) {
                    if ([[p2 class]isSubclassOfClass:[Neutron class]]) {
                        [self calculateForceOn:[p1 proton] dueTo:[p2 proton]];
                        [self calculateForceOn:[p1 proton] dueTo:[p2 electron]];
                        [self calculateForceOn:[p1 electron] dueTo:[p2 proton]];
                        [self calculateForceOn:[p1 electron] dueTo:[p2 electron]];
                    } else {
                        [self calculateForceOn:[p1 proton] dueTo:p2];
                        [self calculateForceOn:[p1 electron] dueTo:p2];
                    }
                } else {
                    if ([[p2 class]isSubclassOfClass:[Neutron class]]) {
                        [self calculateForceOn:p1 dueTo:[p2 proton]];
                        [self calculateForceOn:p1 dueTo:[p2 electron]];
                    } else {
                        [self calculateForceOn:p1 dueTo:p2];
                    }
                }
            }
        }
    }
}
- (void)calculateForceOn:(Particle *)p1 dueTo:(Particle *)p2
{
    Vector2D *r = [Vector2D sub:p2.displacement with:p1.displacement];
    float rLength = [r length];
    Vector2D *forceDirection = [r normalize];
    int factorial = 1;
    for (int i = 0; i<p1.lengthForceVector; i++) {
        factorial*=(i+1);
        
        float forceMagnitude = p1.charge*p2.charge / (p1.mass) * \
        powf(-_deltaT/rLength, (float)(i+1)) * \
        1.0f/factorial;
        Vector2D *forceVector = [Vector2D mult:forceDirection with:forceMagnitude];
        
        [p1.forceVector replaceObjectAtIndex:i withObject:forceVector];
    }
}
- (void)drawRect:(CGRect)rect
{
    [self drawParticles];
}
- (void)drawParticles
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (Particle *particle in _listOfParticles) {
        CGContextSetFillColorWithColor(context, particle.color.CGColor);
        CGContextSetStrokeColorWithColor(context, particle.color.CGColor);
        CGContextStrokeEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, 10.0, 10.0));
        CGContextFillEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, 10.0, 10.0));
    }
}
@end
