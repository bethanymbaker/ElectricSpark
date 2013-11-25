//
//  ElectricSparkView.m
//  ElectricSpark
//
//  Created by Bethany Simmons on 11/24/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import "ElectricSparkView.h"
#import "Electron.h"

@interface ElectricSparkView ()
@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSMutableArray *listOfElectrons;
- (void)drawElectrons;
@end

@implementation ElectricSparkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor magentaColor];
        _listOfElectrons = [[NSMutableArray alloc]init];
    }
    return self;
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
    }
}
- (void)drawRect:(CGRect)rect
{
    [self drawElectrons];
}
- (void) drawElectrons
{
    UIColor *color = [UIColor yellowColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    for (Electron *electron in _listOfElectrons) {
        CGContextStrokeEllipseInRect(context, CGRectMake(electron.currentLocation.x, electron.currentLocation.y, 10.0, 10.0));
        CGContextFillEllipseInRect(context, CGRectMake(electron.currentLocation.x, electron.currentLocation.y, 10.0, 10.0));
    }
}
@end
