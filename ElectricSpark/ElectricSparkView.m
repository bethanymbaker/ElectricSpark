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
- (void)drawParticles;
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
    for (Particle *particle in _listOfParticles) {
        Vector2D *initialDisplacement = particle.displacement;
        Vector2D *initialVelocity = particle.velocity;
        Vector2D *initialAcceleration = [particle.force div:particle.mass];
        Vector2D *finalDisplacement = [[initialDisplacement add:[initialVelocity mult:_deltaT]] add:[initialAcceleration mult:0.5f*_deltaT*_deltaT]];
        Vector2D *finalVelocity = [initialVelocity add:[initialAcceleration mult:_deltaT]];
        particle.displacement = finalDisplacement;
        particle.velocity = finalVelocity;
    }
}
- (void)calculateForces
{
    float strongForce = 100.0f;
    float electrostaticForceWeight = strongForce * 1.0f/137.0f;
    float repulsiveForceWeight = strongForce * 0.000001f;
    
    [self calculateElectrostaticForces];
    [self calculateRepulsiveForces];
    for (Particle *particle in _listOfParticles) {
        [particle.force add:[particle.electrostaticForce mult:electrostaticForceWeight]];
        [particle.force add:[particle.repulsiveForce mult:repulsiveForceWeight]];
    }
}
- (void)calculateElectrostaticForces
{
    //CGRect viewRect = [[UIScreen mainScreen]bounds];
    //int height = viewRect.size.height;
    //int width = viewRect.size.height;
    
    int numParticles = [_listOfParticles count];
    for (int i = 0; i<numParticles; i++) {
        for (int j = i+1; j<numParticles; j++) {
            Particle *p1 = [_listOfParticles objectAtIndex:i];
            Particle *p2 = [_listOfParticles objectAtIndex:j];
            Vector2D *r = [Vector2D sub:p2.displacement with:p1.displacement];
            Vector2D *forceDirection = [r normalize];
            int forceMagnitude = -(p1.charge*p2.charge)/[r lengthSquared];
            Vector2D *electrostaticForce = [Vector2D mult:forceDirection with:forceMagnitude];
            
            [p1.electrostaticForce add:electrostaticForce];
            [p2.electrostaticForce add:[Vector2D mult:electrostaticForce with:-1.0f]];
        }
    }
}
- (void)calculateRepulsiveForces
{
    //CGRect viewRect = [[UIScreen mainScreen]bounds];
    //int height = viewRect.size.height;
    //int width = viewRect.size.height;
    
    int numParticles = [_listOfParticles count];
    for (int i = 0; i<numParticles; i++) {
        for (int j = i+1; j<numParticles; j++) {
            Particle *p1 = [_listOfParticles objectAtIndex:i];
            Particle *p2 = [_listOfParticles objectAtIndex:j];
            Vector2D *r = [Vector2D sub:p1.displacement with:p2.displacement];
            Vector2D *forceDirection = [r normalize];

            float rLength = [r length];
            int forceMagnitude = 1.0f / powf(rLength,6.0f);
            Vector2D *repulsiveForce = [Vector2D mult:forceDirection with:forceMagnitude];
            
            [p1.repulsiveForce add:repulsiveForce];
            [p2.repulsiveForce add:[Vector2D mult:repulsiveForce with:-1.0f]];
        }
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
