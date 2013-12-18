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
#import "Hydrogen.h"

@interface ElectricSparkView ()
@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSMutableArray *listOfParticles;
@property (nonatomic) float deltaT;
@property (nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@property int numberOfTaylorSeriesTerms;
@property float particleSize;
@property BOOL hydrogenAtomsMayForm;
@property float timeInterval;
@end

@implementation ElectricSparkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _deltaT = 0.25f;
        _timeInterval = 1.0f/40.0f * _deltaT;
        _hydrogenAtomsMayForm = YES;
        _numberOfTaylorSeriesTerms = 10;
        self.backgroundColor = [UIColor whiteColor];
        _listOfParticles = [[NSMutableArray alloc]init];
        _particleSize = 15.0f;
        _singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addElectron:)];
        _singleTapRecognizer.delaysTouchesEnded = YES;
        _singleTapRecognizer.numberOfTapsRequired = 1;
        
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addProton:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
        
        [_singleTapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
        
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addNeutron:)];
        [_singleTapRecognizer requireGestureRecognizerToFail:_longPressRecognizer];
        [_doubleTapRecognizer requireGestureRecognizerToFail:_longPressRecognizer];
        
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
    [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(animate) userInfo:NULL repeats:NO];
    [self calculateForces];
    [self calculateDisplacements];
    [self setNeedsDisplay];
}
- (void)calculateDisplacements
{
    for (Particle *particle in _listOfParticles) {
        [particle.displacement add:particle.force];
    }
}
- (void)calculateForces
{
    BOOL hydrogenBreak = NO;
    
    for (Particle *p1 in _listOfParticles) {
        Vector2D *force = [[Vector2D alloc]init];
        for (Particle *p2 in _listOfParticles) {
            force = [force add:[self calculateForceOn:p1 dueTo:p2]];
            
                // If p2 annihilation
                if (!p2.color) {
                    hydrogenBreak = YES;
                    break;
                }
        }
        if (hydrogenBreak) {
            break;
        } else {
           p1.force = force;
        }
    }
}
- (Vector2D *)calculateForceOn:(id)p1 dueTo:(id)p2
{
    Vector2D *force = [[Vector2D alloc]init];
    
    if (![p1 isEqual:p2]) {
        Vector2D *r = [Vector2D sub:[p2 displacement] with:[p1 displacement]];
        float rLength = [r length];
        
        if ([r isZero]) {
            
            // Make hydrogen atom
            if ([[p1 class]isSubclassOfClass:[Proton class]]) {
                if ([[p2 class]isSubclassOfClass:[Electron class]]) {
                    CGPoint locationOfTouch = CGPointMake([p1 displacement].x, [p1 displacement].y);
                    Hydrogen *hydrogen = [[Hydrogen alloc]initWithLocationOfTouch:locationOfTouch];
                    [_listOfParticles removeObject:p1];
                    [_listOfParticles removeObject:p2];
                    [_listOfParticles addObject:hydrogen];
                    return force;
                }
            } else if ([[p1 class]isSubclassOfClass:[Electron class]]) {
                if ([[p2 class]isSubclassOfClass:[Proton class]]) {
                    CGPoint locationOfTouch = CGPointMake([p2 displacement].x, [p2 displacement].y);
                    Hydrogen *hydrogen = [[Hydrogen alloc]initWithLocationOfTouch:locationOfTouch];
                    [_listOfParticles removeObject:p1];
                    [_listOfParticles removeObject:p2];
                    [_listOfParticles addObject:hydrogen];
                    return force;
                }
                
            }
            //
            
        }
        
        float mass = [p1 mass];
        Vector2D *forceDirection = [r normalize];
        
        if (![[p1 class]isSubclassOfClass:[Neutron class]] && \
            ![[p2 class]isSubclassOfClass:[Neutron class]]) {
            //
            for (int i = 0; i<_numberOfTaylorSeriesTerms; i++) {
                float charge1 = [p1 charge];
                float charge2 = [p2 charge];
                
                float forceMagnitude = charge1 * charge2 / mass * \
                powf(-(_deltaT/rLength), (float)(i+1)) * \
                1.0f/(i+1);
                
                force = [force add:[Vector2D mult:forceDirection with:forceMagnitude]];
            }
            //
        }
        
    }
    return force;
}
- (void)drawRect:(CGRect)rect
{
    [self drawParticles];
}
- (void)drawParticles
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (Particle *particle in _listOfParticles) {
        CGContextSetAlpha(context, particle.alpha);
        CGContextSetFillColorWithColor(context, particle.color.CGColor);
        CGContextSetStrokeColorWithColor(context, particle.color.CGColor);
        CGContextStrokeEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, _particleSize, _particleSize));
        CGContextFillEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, _particleSize, _particleSize));
    }
}
- (int)factorial:(int)n
{
    int factorial = 1;
    for (int i = 1; i<n+1; i++) {
        factorial*=i;
    }
    return factorial;
}
@end
