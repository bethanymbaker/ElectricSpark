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

@interface ElectricSparkView ()
@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSMutableArray *listOfParticles;
@property (nonatomic) float deltaT;
@property (nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic) UITapGestureRecognizer *doubleTapRecognizer;
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
        
        [self addGestureRecognizer:_singleTapRecognizer];
        [self addGestureRecognizer:_doubleTapRecognizer];
        [self setMultipleTouchEnabled:YES];
        [self animate];
    }
    return self;
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
    [NSTimer scheduledTimerWithTimeInterval:_deltaT target:self selector:@selector(animate) userInfo:NULL repeats:NO];
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
    for (Particle *p1 in _listOfParticles) {
        for (Particle *p2 in _listOfParticles) {
            if (![p1 isEqual:p2]) {
                Vector2D *deltaR = [Vector2D sub:p2.displacement with:p1.displacement];
                float length = [deltaR length];
                float magnitude = - 10000.0 * ( p1.charge * p2.charge ) / (length*length*length);
                Vector2D *force = [Vector2D mult:deltaR with:magnitude];
                [p1.force add:force];
            }
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
