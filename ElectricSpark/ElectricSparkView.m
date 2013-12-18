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
@property (nonatomic) int timeSpeedUpFactor;
@property (nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@property int numberOfTaylorSeriesTerms;
@property float particleSize;
@property BOOL hydrogenAtomsMayForm;
@property float timeInterval;
@property BOOL simulateAntimatter;
@end

@implementation ElectricSparkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _simulateAntimatter = NO;
        _timeSpeedUpFactor = 10;
        _deltaT = 0.25f;
        _timeInterval = _deltaT/_timeSpeedUpFactor;
        _hydrogenAtomsMayForm = YES;
        _numberOfTaylorSeriesTerms = 10;
        self.backgroundColor = [UIColor whiteColor];
        _listOfParticles = [[NSMutableArray alloc]init];
        _particleSize = 15.0f;
        _singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addParticle:)];
        _singleTapRecognizer.delaysTouchesEnded = YES;
        _singleTapRecognizer.numberOfTapsRequired = 1;
        
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addParticle:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
        
        [_singleTapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
        
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addParticle:)];
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
- (void)addParticle:(UIGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view self]];
    Particle *particle;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer isEqual:_singleTapRecognizer]) {
            particle = [[Electron alloc]initWithLocationOfTouch:location];
        } else if ([recognizer isEqual:_doubleTapRecognizer]) {
            particle = [[Proton alloc]initWithLocationOfTouch:location];
        } else if ([recognizer isEqual:_longPressRecognizer]) {
            particle = [[Neutron alloc]initWithLocationOfTouch:location];
        }
    }
    
    if (particle) {
        [_listOfParticles addObject:particle];
        [self setNeedsDisplay];
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
            
                // If p1 annihilation
                if (!p1.color) {
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
        if ([r isZero]) {
            // Make new particle
            Particle *particle = [[Particle alloc]initWithParticle:p1 andParticle:p2];
            if (particle) {
                [_listOfParticles removeObject:p1];
                [_listOfParticles removeObject:p2];
                [_listOfParticles addObject:particle];
            }
        } else {
            if ([p1 charge] && [p2 charge]) {
                for (int i = 0; i<_numberOfTaylorSeriesTerms; i++) {
                    float rLength = [r length];
                    Vector2D *forceDirection = [r normalize];
                    float forceMagnitude = [p1 charge] * [p2 charge] * \
                    1.0f/powf([p1 radius], (float)(i+2)) * \
                    powf(-(_deltaT/rLength), (float)(i+1)) * \
                    1.0f/(i+1);
                    
                    force = [force add:[Vector2D mult:forceDirection with:forceMagnitude]];
                }
            }
        }
    }
    return  force;
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
        //CGContextFillEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, particle.radius, particle.radius));
        CGContextFillEllipseInRect(context, CGRectMake(particle.displacement.x, particle.displacement.y, _particleSize, _particleSize));
    }
}
@end
